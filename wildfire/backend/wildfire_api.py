
from flask import Flask, request, jsonify
import osmnx as ox
import networkx as nx
import geopandas as gpd
import pandas as pd
from shapely.geometry import Point

app = Flask(__name__)

# 🔗 NASA FIRMS API
CSV_URL ="https://firms.modaps.eosdis.nasa.gov/api/area/csv/c357f289ae3d51d70296fb753ed93912/VIIRS_SNPP_NRT/world/1/2025-04-08"


@app.route('/')
def home():
    return "🔥 Wildfire Evacuation API is running!"

@app.route('/wildfires')
def get_fire_zones():
    try:
        df = pd.read_csv(CSV_URL)
        gdf = gpd.GeoDataFrame(
            df,
            geometry=gpd.points_from_xy(df.longitude, df.latitude),
            crs="EPSG:4326"
        )
        gdf['geometry'] = gdf.to_crs(epsg=3857).buffer(500).to_crs(epsg=4326)  # 500m buffer
        return gdf.to_json()
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/get_safe_route', methods=['POST'])
def get_safe_route():
    data = request.get_json()
    start = tuple(data['start'])  # [lat, lon]
    end = tuple(data['end'])

    # 📍 Get road network
    G = ox.graph_from_point(start, dist=5000, network_type='drive')

    # 🔥 Load dynamic fire zones from NASA
    try:
        df = pd.read_csv(CSV_URL)
        fire_gdf = gpd.GeoDataFrame(
            df,
            geometry=gpd.points_from_xy(df.longitude, df.latitude),
            crs="EPSG:4326"
        )
        fire_gdf['geometry'] = fire_gdf.to_crs(epsg=3857).buffer(500).to_crs(epsg=4326)
    except Exception as e:
        return jsonify({'error': f"NASA API failed: {str(e)}"}), 500

    # 🔀 Filter out roads near fire
    edges = ox.graph_to_gdfs(G, nodes=False, edges=True)
    safe_edges = edges[~edges.intersects(fire_gdf.unary_union)]
    G_safe = ox.gdfs_to_graph(None, safe_edges)

    # 🧭 Route computation
    try:
        orig = ox.distance.nearest_nodes(G_safe, start[1], start[0])
        dest = ox.distance.nearest_nodes(G_safe, end[1], end[0])
        route = nx.shortest_path(G_safe, orig, dest, weight="length")
        coords = [(G_safe.nodes[n]['y'], G_safe.nodes[n]['x']) for n in route]
        return jsonify({'route': coords})
    except Exception as e:
        return jsonify({'error': f"Could not find safe path: {str(e)}"}), 500


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
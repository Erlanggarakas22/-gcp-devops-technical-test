import os
import logging
import socket
from datetime import datetime

import psycopg2
from flask import Flask, jsonify

app = Flask(__name__)

logging.basicConfig(level=logging.INFO)


def get_database_connection():
    return psycopg2.connect(
        host=os.getenv("DB_HOST"),
        port=os.getenv("DB_PORT", "5432"),
        database=os.getenv("DB_NAME"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        connect_timeout=5,
    )


@app.route("/", methods=["GET"])
def index():
    return jsonify(
        application="gcp-devops-technical-test",
        message="Hello from Cloud Run V2",
        status="running",
        version="manual-v7",
        hostname=socket.gethostname(),
        environment=os.getenv("ENV", "development"),
        timestamp=datetime.utcnow().isoformat() + "Z",
    ), 200


@app.route("/version", methods=["GET"])
def version():
    return jsonify(
        application="gcp-devops-technical-test",
        version="manual-v7",
        flask="3.1.1",
    ), 200


@app.route("/health", methods=["GET"])
def health():
    return jsonify(
        application="gcp-devops-technical-test",
        status="healthy",
    ), 200


@app.route("/ready", methods=["GET"])
def ready():
    return jsonify(
        status="ready",
    ), 200


@app.route("/info", methods=["GET"])
def info():
    return jsonify(
        hostname=socket.gethostname(),
        environment=os.getenv("ENV", "development"),
        python_version=os.sys.version.split()[0],
    ), 200


@app.route("/dbcheck", methods=["GET"])
def dbcheck():
    try:
        conn = get_database_connection()
        conn.close()

        return jsonify(
            status="ok",
            database="connected",
        ), 200

    except Exception as e:
        logging.exception(e)

        return jsonify(
            status="error",
            error=str(e),
        ), 500


if __name__ == "__main__":
    app.run(
        host="0.0.0.0",
        port=int(os.getenv("PORT", "8080")),
    )

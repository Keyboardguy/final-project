from flask import (
    Blueprint, render_template, request
)

from menu_package.db import get_db

bp = Blueprint('menu', __name__)

@bp.route("/")
def index():
    return render_template("menu/index.html")

@bp.route("/search")
def return_results():
    query = request.args.get("q")

    if query == None:
        return None
    
    db = get_db()

    return db.execute(
        "SELECT *"
        "  FROM dishes JOIN type ON type.id = dishes.type_id"
        " ORDER BY menu_number ASC"
    ).fetchall()






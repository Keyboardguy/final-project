from flask import (
    Blueprint, render_template, request, session, jsonify
)

from menu_package.db import get_db

bp = Blueprint('menu', __name__)

@bp.before_app_request
def initialize():
    if "current_dishes" not in session:
        session["current_dishes"] = {}

@bp.route("/")
def index():
    """Render index page."""
    return render_template("menu/index.html")

@bp.route("/basket")
def basket():
    """Render basket page with items in basket."""
    dishes_in_basket = []
    total = 0

    db = get_db()
    for id in session["current_dishes"]:
        dish = db.execute(
            "SELECT *, type.name AS type_name"
            "  FROM dishes JOIN type ON type.id = dishes.type_id"
            " WHERE dishes.id = ?",
            (id,)
        ).fetchone()
        dishes_in_basket.append(dish)
        total += dish["price"] * session["current_dishes"][id]
    
    dishes_in_basket.sort(key=lambda dish: dish["menu_number"])
    return render_template("menu/basket.html", dishes=dishes_in_basket, total=total)


@bp.route("/search")
def return_results():
    """Returns dishes in database with the query string in their name."""
    query = request.args.get("q")

    if query == None:
        return None
    
    query = f"%{query}%"

    db = get_db()
    dishes = db.execute(
        "SELECT *, type.name AS type_name"
        "  FROM dishes JOIN type ON type.id = dishes.type_id"
        " WHERE dishes.name LIKE ?"
        " ORDER BY menu_number ASC",
        (query,)
    ).fetchall()

    # https://stackoverflow.com/questions/3286525/return-sql-table-as-json-in-python
    # 2nd top answer, i may use this if i ever need to return json.
    return render_template("menu/query.html", dishes=dishes, hidden=True)

@bp.route("/add_basket", methods=["POST"])
def add_basket_items():
    """Returns JSON of the price of the item and the new count."""
    dish_id, num_to_add = get_form_results()
    return jsonify({
        "price": get_price(int(dish_id)),
        "new_count": add_items([dish_id, num_to_add])
    })
    

@bp.route("/delete_basket", methods=["POST"])
def delete_basket_items():
    """Returns JSON of the price of the item and the new count."""
    dish_id, num_to_add = get_form_results()
    return jsonify({
        "price": get_price(int(dish_id)),
        "new_count": delete_items([dish_id, num_to_add])
    })
    
def get_price(id):
    """Returns price as a float of the given id."""
    db = get_db()
    return db.execute(
        "SELECT price"
        "  FROM dishes"
        " WHERE id = ?",
        (id,)
    ).fetchone()[0]

@bp.route("/add", methods=["POST"])
def add_items(form_results=None):
    """Adds a number of items of a certain id from session["current_dishes"]."""

    # TODO - I could make a generic function, since add_items and delete_items do nearly the same thing.
    # Note - The return type must be a string, dict, list, tuple with headers or status, Response instance, or WSGI callable, but it was a int.
    # So this function and the next one returns string representations of numbers.
    if form_results is None:
        form_results = get_form_results()

    dish_id, num_to_add = form_results

    if dish_id is None or num_to_add is None:
        return "Error"
    
    current_dishes = {}
    new_count = 0
    # The keys in session["current_dishes"] keeps getting type casted into a string.
    # So, i decided that dish_id in the dict is a STRING.
    for id, value in session["current_dishes"].items():
        if id == dish_id:
            value += num_to_add
            new_count = value
        current_dishes[id] = value
    
    if new_count == 0:
        print(dish_id)
        current_dishes[dish_id] = num_to_add
        new_count = num_to_add
    session["current_dishes"] = current_dishes
    return str(new_count)


@bp.route("/delete", methods=["POST"])
def delete_items(form_results=None):
    """Deletes a number of items of a certain id from session["current_dishes"]."""
    if form_results is None:
        form_results = get_form_results()

    dish_id, num_to_add = form_results

    if dish_id is None or num_to_add is None:
        return "Error"
    
    current_dishes = {}
    new_count = 0
    for id, value in session["current_dishes"].items():
        if id == dish_id:
            value += num_to_add
            if value <= 0:
                continue
            new_count = value
        current_dishes[id] = value
        
    session["current_dishes"] = current_dishes
    return str(new_count)


def get_form_results():
    """Returns a STRING dish_id and an INT num_to_add from a form."""
    dish_id = request.form.get("dish_id")
    num_to_add = request.form.get("number")

    try:
        int(dish_id)
        num_to_add = int(num_to_add)
    except ValueError:
        return None, None

    return dish_id, num_to_add
    



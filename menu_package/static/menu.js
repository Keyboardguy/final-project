const search_bar = document.getElementById("menu-search");
const results_list = document.getElementById("results");

search_bar.addEventListener("input", async function() {
    const fetch_promise = await fetch(`/search?q=${search_bar.value}`);
    results_list.innerHTML = await fetch_promise.text();
    attach_listeners();
})

function attach_listeners() {
    function attach_button_listener(button, fetch_url, dish_id, num, output_element) {
        const form_data = new URLSearchParams();
        form_data.append("dish_id", dish_id);
        form_data.append("number", num);

        button.addEventListener("click", async function() {
            const fetch_promise = await fetch(fetch_url, {
                method: "POST",
                body: form_data,
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                }
            })
            output_element.innerHTML = await fetch_promise.text();
        })
    }

    // make each menu item expandable
    const list_items = document.querySelectorAll("#results > li");
    for (const li of list_items) {
        const name = li.children[0];
        const details = li.children[1];
        
        name.addEventListener("click", () => {
            if (details.classList.contains("hidden")) {
                details.classList.remove("hidden");
            } else {
                details.classList.add("hidden");
            }
        });
    }

    // make the buttons on the menu item work
    const buttons_divs = document.querySelectorAll(".add_delete");

    for (const div of buttons_divs) {
        const add_button = div.children[0];
        const delete_button = div.children[1];
        const span = div.children[2];
        const dish_id = div.children[3].value;

        attach_button_listener(add_button, "/add", dish_id, 1, span);
        attach_button_listener(delete_button, "/delete", dish_id, -1, span);
    }
}

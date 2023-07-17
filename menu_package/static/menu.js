const search_bar = document.getElementById("menu-search");
const results_list = document.getElementById("results");

search_bar.addEventListener("input", async function() {
    const fetch_promise = await fetch(`/search?q=${search_bar.value}`);
    results_list.innerHTML = await fetch_promise.text();
    attach_listeners();
})

function attach_listeners() {
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
}
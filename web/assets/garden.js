document.body.onload = addElement;
function addElement() {

    //Set # of columns
    const gridContainer = document.querySelector(".grid-container");
    const GRID_COLUMNS = gridContainer.dataset.gridcolumns;
    gridContainer.style.setProperty('--grid-columns', GRID_COLUMNS);
    //parse json for user's boxes
    //
    //generate grid off that json
    const json = JSON.parse(gridContainer.dataset.imgjson);
    let i;
    for (i = 0; i < GRID_COLUMNS * GRID_COLUMNS; i++) {
        const newDiv = document.createElement("div");
        const id = i + 1;
        //                  newDiv.textContent = id;
        newDiv.dataset.id = id;
        newDiv.dataset.plantid = json[id].plant_id;
        newDiv.setAttribute('class', 'grid-item');
        const newImg = document.createElement("img");
        newImg.src = json[id].plant_url;
        newImg.style.width = "80px";
        newImg.style.height = "80px";
        newDiv.onclick = () => {
            console.log(newDiv.dataset.id + " was clicked on!:");
            console.log(newDiv);
        }


        document.getElementById('grid').appendChild(newDiv);
        document.querySelector("[data-id=" + CSS.escape(id) + "]").appendChild(newImg);
    }
}

function allowDrop(ev) {
    ev.preventDefault();
}

function drag(ev) {
    ev.dataTransfer.setData("text", ev.target.id);
}

function drop(ev) {
    ev.preventDefault();
    var data = ev.dataTransfer.getData("text");
    ev.target.appendChild(document.getElementById(data));
}

document.body.onload = addElement;
function addElement() {
    document.querySelector("input.plantButton").disabled = true;
    document.querySelector("input.harvestButton").disabled = true;

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
        newDiv.dataset.age = json['farm_age'] - json[id]['day_planted'];
        newDiv.dataset.daysToHarvest = json[id].daysToHarvest
        newDiv.setAttribute('id', 'div1');
        newDiv.setAttribute('class', 'grid-item');
        newDiv.setAttribute('ondrop', 'drop(event)');
        newDiv.setAttribute('ondragover', 'allowDrop(event)');



        if (json[id].plant_url != null)
        {
            const newImg = document.createElement("img");
            newImg.src = json[id].plant_url;

            newImg.style.width = "80px";
            newImg.style.height = "80px";

            document.getElementById('grid').appendChild(newDiv);

            document.querySelector("[data-id=" + CSS.escape(id) + "]").appendChild(newImg);

        }


        newDiv.onclick = () => {
            if (Number.parseInt(newDiv.dataset.age, 10) < Number.parseInt(newDiv.dataset.daysToHarvest, 10)) {
                alert(`Not ready for harvest! ${newDiv.dataset.age} out of ${newDiv.dataset.daysToHarvest} days complete.`);
            } else {

                document.getElementById("harvestForm:harvestLocation").value = newDiv.dataset.id;
                var i = newDiv.getElementsByTagName('img')[0];
                i.parentNode.removeChild(i);
                document.querySelector(".harvestButton").disabled = false;
                document.querySelector(".harvestButton").click();
            }
        }

        document.getElementById('grid').appendChild(newDiv);
    }

    var selectMenu = document.getElementById("seedSelect");
    const plantJson = JSON.parse(selectMenu.dataset.seedjson);
    Object.keys(plantJson).forEach(function (key) {
        var opt = document.createElement("option");
        opt.value = plantJson[key].name;
        opt.text = plantJson[key].name + " (" + plantJson[key].quantity + ")";
        selectMenu.options.add(opt);
    });

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
    console.log(data);
    clone = document.getElementById(data).cloneNode(true);
    clone.id = "changed";
    clone.removeAttribute('draggable');
    clone.removeAttribute('ondragstart');
    console.log(ev.target.dataset.id + "   " + clone.getAttribute("seedid"));
    let curId = ev.target.dataset.id;

    ev.target.appendChild(clone);
    document.getElementById("plantForm:loc").value = curId;
    document.getElementById("plantForm:seedid").value = clone.getAttribute("seedid");
    document.querySelector(".plantButton").disabled = false;
    document.querySelector(".plantButton").click();

}

function changeimage(seedName) {

    var selectMenu = document.getElementById("seedSelect");
    const plantJson = JSON.parse(selectMenu.dataset.seedjson);
    Object.keys(plantJson).forEach(function (key) {
        if (seedName === plantJson[key].name) {
            let selectorImage = document.getElementById("change");
            selectorImage.setAttribute('seedid', key);
            selectorImage.setAttribute('src', plantJson[key].image_url);
            selectorImage.setAttribute('draggable', 'true');
            console.log("seedid " + key);
            
        }
    });
    if (seedName === "select") {
        document.getElementById("change").setAttribute('src', '../assets/seeds_bag.jpg');
        document.getElementById("change").setAttribute('draggable', 'false');
    }
}
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
        newDiv.dataset.age = json['farm_age'] - json[id]['day_planted'];
        newDiv.dataset.daysToHarvest = json[id].daysToHarvest
        newDiv.setAttribute('id', 'div1');
        newDiv.setAttribute('class', 'grid-item');
        newDiv.setAttribute('ondrop', 'drop(event)');
        newDiv.setAttribute('ondragover', 'allowDrop(event)');
 

        const newSpan = document.createElement("span");
        
        if (json[id].plant_url != null)
        {
            const newImg = document.createElement("img");
            newImg.src = json[id].plant_url;

            newImg.style.width = "60px";
            newImg.style.height = "60px";
            document.getElementById('grid').appendChild(newDiv);
            newSpan.appendChild(newImg);
            
            if (id < 5)
            {
                const testImg = document.createElement("img");
                testImg.setAttribute('src', '../assets/check.png');

                testImg.style.margin = "2px";
                testImg.style.width = "20px";
                testImg.style.height = "20px";
                newSpan.appendChild(testImg);
            }
            
            document.querySelector("[data-id=" + CSS.escape(id) + "]").appendChild(newSpan);
    
        }
        
        
                    

        newDiv.onclick = () => {
            if (newDiv.dataset.age < newDiv.dataset.daysToHarvest) {
                alert('Not ready for harvest!');
            } else {
                var i = newDiv.getElementsByTagName('img')[0];
                i.parentNode.removeChild(i);
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

var myJSON = {};

function drop(ev) {
    ev.preventDefault();
    var data = ev.dataTransfer.getData("text");

    clone = document.getElementById(data).cloneNode(true);
    clone.id = "changed";
    clone.removeAttribute('draggable');
    clone.removeAttribute('ondragstart');
    console.log(ev.target.dataset.id + "   " + clone.getAttribute("seedid"));
    let curId = ev.target.dataset.id;
    
  
//    ev.target.appendChild(clone);
//    var form = document.getElementById("formId");
//    function handleForm(event) { event.preventDefault(); } 
//    form.addEventListener('submit', handleForm);
    document.getElementById("formId:loc").value = curId;
    document.getElementById("formId:seedid").value = clone.getAttribute("seedid");
    document.getElementById("formId").submit();
    
    
    // decrease seed count by one
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
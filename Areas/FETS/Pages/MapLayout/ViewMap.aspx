<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewMap.aspx.cs" Inherits="FETS.Pages.MapLayout.ViewMap" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>View Map - FETS</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <link href="<%= ResolveUrl("~/Areas/FETS/Assets/css/styles.css") %>" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/choices.js/public/assets/styles/choices.min.css"/>
    <style>
        header > 

        .dashboard-container {
            min-height: 100vh;
            background-color: #f5f6fa;
        }

        .dashboard-header {
            background: #1a2e4a;
            padding: 1rem 2rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: white;
        }

        .dashboard-header h2 {
            margin: 0;
            color: #ffffff;
            font-size: 1.8rem;
            font-weight: 600;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 1rem;
            color: white;
        }

        .user-info label {
            color: #aaa;
        }

        .btn-close {
            padding: 0.5rem 1rem;
            border: 2px solid rgba(255, 255, 255, 0.4);
            border-radius: 15px;
            font-weight: 500;
            color: white;
            text-decoration: none;
            transition: all 0.2s ease;
        }

        .btn-close:hover {
            background: rgba(255, 255, 255, 0.2);
            border-color: rgba(255, 255, 255, 0.3);
            color: white;
        }

        .content-container {
            padding: 2rem;
        }

        .map-container {
            width: 100%;
            max-width: 800px;
            margin: 0 auto;
            overflow-x: auto;
            border: 1px solid #ddd;
            border-radius: 4px;
            background: #f8f8f8;
        }

        .map-section {
            display: inline-block;
            min-width: 100%;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .map-header {
            padding: 1rem 1.5rem;
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .map-header h3 {
            margin: 0;
            color: #333;
            font-size: 1.2rem;
            font-weight: 500;
        }

        /* map-wrapper sizes itself to the image naturally */
        .map-wrapper {
            position: relative;
            display: inline-block;
            width: 100%;
        }

        .map-magnifier-glass {
            position: absolute;
            border: 3px solid #000;
            border-radius: 50%;
            cursor: none;
            width: 100px;
            height: 100px;
        }

        .map-magnifier-glass::before,
        .map-magnifier-glass::after {
            content: '';
            position: absolute;
            background: rgba(0, 0, 0, 0.45);
            pointer-events: none;
        }

        /* horizontal arm */
        .map-magnifier-glass::before {
            top: 50%;
            left: 15%;
            width: 70%;
            height: 1px;
            transform: translateY(-50%);
        }

        /* vertical arm */
        .map-magnifier-glass::after {
            left: 50%;
            top: 15%;
            height: 70%;
            width: 1px;
            transform: translateX(-50%);
        }

        .map-image {
            display: block;
            max-width: 100%;
            height: auto;
        }

        .map-context-menu {
            position: fixed;
            display: none;
            background: white;
            border: 1px solid #333;
            border-radius: 4px;
        }

        .map-context-menu.visible {
            display: block;
        }

        .filter-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            margin-bottom: 10px;
        }

        .pin-status-toggle {
            display: flex;
            background: #f0f0f0;
            border-radius: 20px;
            padding: 3px;
            gap: 2px;
        }

        .pin-status-toggle input[type="radio"]:checked + label{
            background: white;
            color: #2c3e50;
            box-shadow: 0 1px 4px rgba(0,0,0,0.15);
        }

        .pin-status-toggle input[type="radio"] {
            display: none;
        }

        .pin-status-toggle label{
            padding: 4px 12px;
            font-size: 0.78rem;
            font-weight: 500;
            color: #666;
            border-radius: 16px;
            cursor: pointer;
            transition: all 0.2s ease;
            display: block;
        }

        .pin-status-toggle::before {
            display: none;
        }

        .pin-status-toggle:has(#allStatus:checked)::before{
            left: 0%;
        }
        .pin-status-toggle:has(#pinnedStatus:checked)::before{
            left: 33%;
        }
        .pin-status-toggle:has(#unpinnedStatus:checked)::before{
            left: 66%;
        }

        #feModal {
            position: fixed;
            inset: 0;
            background: rgba(0, 0, 0, 0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 100;
        }

        #feModal h3 {
            color: #333;
            margin-top: 0;
            border-bottom: 1px solid #eee;
        }

        #feModal label {
            display: block;
        }

        #feModal select {
            width: 100%;
            border: 1px solid #ddd;
            border-radius: 8px;
            height: 30px;
            box-sizing: border-box;
        }

        #feModal select:focus {
            border-color: #ddd;
            outline: none;
            box-shadow: none;
        }

        #feModal button {
            padding: 6px 14px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.9rem;
            transition: background 0.2s;
        }

        #feModal input[type="search"] {
            width: 100%;
            padding: 6px 10px;
            margin: 10px 0;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }

        #feModal > div {
            background: white;
            border-radius: 15px;
            padding: 20px 30px;
            width: 600px;
            box-sizing: border-box;
        }

        #feModal .choices {
            width: 100%;
            box-sizing: border-box;
        }

        #feModal .choices__inner {
            box-sizing: border-box;
            width: 100%;
        }

        #feModal .row {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
        }

        #feModal .row button {
            width: 100px;
            flex: none;
        }

        .last-updated {
            font-size: 0.8rem;
            color: #666;
            background: rgba(240, 240, 240, 0.8);
            padding: 4px 10px;
            border-radius: 4px;
        }


        .marker {
            position: absolute;
            width: 8px;
            height: 8px;
            transform: translate(-50%, -50%);
            cursor: pointer;
            z-index: 10;
        }

        .marker-icon {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            box-shadow: 0 2px 4px rgba(0,0,0,0.3);
        }

        .marker-info {
            position: absolute;
            bottom: 100%;
            left: 50%;
            transform: translateX(-50%);
            background: white;
            border-radius: 4px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
            padding: 10px;
            width: 200px;
            display: none;
            z-index: 20;
        }

        .marker-info:after {
            content: '';
            position: absolute;
            top: 100%;
            left: 50%;
            transform: translateX(-50%);
            border-width: 8px;
            border-style: solid;
            border-color: white transparent transparent transparent;
        }

        .marker.active .marker-info {
            display: block;
        }

        /* Small dot shown inside the magnifier glass when it hovers over a marker */
        .ghost-marker-pin {
            position: absolute;
            width: 8px;
            height: 8px;
            border-radius: 50%;
            transform: translate(-50%, -50%);
            pointer-events: none;
            display: none;
            z-index: 5;
        }

        .hidden-grid {
            display: none;
        }

        .pin-toolbar {
            padding: 10px 15px;
            background: #f0f4ff;
            border-bottom: 1px solid #c9d8ff;
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }

        .btn-pin-toggle {
            padding: 6px 14px;
            background: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.9rem;
            transition: background 0.2s;
        }

        .btn-pin-toggle:hover { background: #0056b3; }

        .btn-pin-toggle.active { background: #28a745; }

        .pin-select {
            padding: 5px 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 0.9rem;
            min-width: 220px;
        }

        .pin-status {
            font-size: 0.85rem;
            color: #007bff;
            font-weight: 500;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="dashboard-container">
            <header class="dashboard-header">
                <h2>Map Layout for: <asp:Label ID="lblPlantNameHeader" runat="server"></asp:Label></h2>
                <div class="user-info">
                    <label>User: <asp:Label ID="lblUsername" runat="server"></asp:Label></label>
                    <a href="javascript:window.close()" class="btn btn-close btn-warning">Close Tab</a>
                </div>
            </header>

            <div class="content-container">

                <div class="map-container">
                    <div class="map-section">
                        <div class="map-header">
                            <h3>
                                <asp:Label ID="lblPlantName" runat="server"></asp:Label> -
                                <asp:Label ID="lblLevelName" runat="server"></asp:Label>
                            </h3>
                            <div style="display:flex; align-items:center; gap:1rem;">
                                <span style="font-size:0.9rem; color:#555;">
                                    FE Count: <asp:Label ID="lblFECount" runat="server">0</asp:Label>
                                </span>
                                <div class="last-updated" style="position:static;">
                                    Last Updated: <asp:Label ID="lblLastUpdated" runat="server"></asp:Label>
                                </div>
                            </div>
                        </div>
                        <div class="map-wrapper">
                            <asp:Image ID="imgMap" runat="server" CssClass="map-image" ClientIDMode="Static"/>
                            <div id="markersContainer"></div>
                            <div id="feList" class="map-context-menu">
                                <button id="modalBtn" type="button">Map Fire Extinguisher</button>
                                <button id="removeBtn" type="button" style="display:none;">Remove Pin</button>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Hidden grid for data binding -->
                <div class="hidden-grid">
                    <asp:GridView ID="gvFireExtinguishers" runat="server" AutoGenerateColumns="false">
                        <Columns>
                            <asp:BoundField DataField="FEID" HeaderText="ID" />
                            <asp:BoundField DataField="SerialNumber" HeaderText="Serial Number" />
                            <asp:BoundField DataField="Location" HeaderText="Location" />
                            <asp:BoundField DataField="TypeName" HeaderText="Type" />
                            <asp:BoundField DataField="DateExpired" HeaderText="Expiration Date" />
                            <asp:BoundField DataField="StatusName" HeaderText="Status" />
                            <asp:BoundField DataField="ColorCode" HeaderText="Color Code" />
                            <asp:BoundField DataField="PinX" HeaderText="X" />
                            <asp:BoundField DataField="PinY" HeaderText="Y" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>

        <div id="feModal" style="display:none;">
            <div>  <!-- inner white card -->
                <h3>Map Fire Extinguisher</h3>
                <div class="filter-row">
                    <label for="feSelect">Select Fire Extinguisher:</label>
                    <div class="pin-status-toggle">

                        <input type="radio" id="allStatus" name="radio" checked/>
                        <label for="allStatus" class="pin-status">All</label>

                        <input type="radio" id="pinnedStatus" name="radio"/>
                        <label for="pinnedStatus" class="pin-status">Pinned</label>

                        <input type="radio" id="unpinnedStatus" name="radio"/>
                        <label for="unpinnedStatus" class="pin-status">Unpinned</label>

                    </div>
                </div>
                <select id="feSelect">
                    <option value="">-- Select Fire Extinguisher --</option>
                </select>
                <div class="row">
                    <button class="btn btn-secondary" id="btnClose" type="button">Close</button>
                    <button class="btn btn-primary" id="btnSave" type="button">Save Pins</button>
                </div>
            </div>
        </div>
    </form>

    <script src="https://cdn.jsdelivr.net/npm/choices.js/public/assets/scripts/choices.min.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const mapWrapper  = document.querySelector(".map-wrapper");
            const mapImage    = document.getElementById("imgMap");
            window._feMarkers = [];
            let pinModeActive = false;

            const MARKER_COLORS = {
                active:   { bg: "#27ae60", border: "#1e8449" },
                inactive: { bg: "#e74c3c", border: "#c0392b" }
            };

            // ── Render pins from hidden GridView ──────────────────────────────
            // Pins use percentage (0.0–1.0) positioned on the wrapper.
            // wrapper is relative, markers are absolute inside it.
            // pinX=0.5 means 50% from left edge of image.
            window._allFeOptions = [];
            var choices = null;

            function loadExtinguisherData() {
                const gridView = document.getElementById("<%= gvFireExtinguishers.ClientID %>");
                if (!gridView) return;

                const glass = document.querySelector(".map-magnifier-glass");
                const rows  = gridView.getElementsByTagName("tr");

                for (let i = 1; i < rows.length; i++) {
                    const cells = rows[i].getElementsByTagName("td");
                    if (cells.length < 9) continue;

                    const feData = {
                        id:       cells[0].textContent.trim(),
                        serial:   cells[1].textContent.trim(),
                        location: cells[2].textContent.trim(),
                        type:     cells[3].textContent.trim(),
                        expiry:   cells[4].textContent.trim(),
                        status:   cells[5].textContent.trim(),
                        pinX:     parseFloat(cells[7].textContent) || null,
                        pinY:     parseFloat(cells[8].textContent) || null
                    };

                    if (feData.pinX !== null && !isNaN(feData.pinX) &&
                        feData.pinY !== null && !isNaN(feData.pinY)) {
                        createMarker(feData, glass);
                    }

                    const pinned = feData.pinX !== null && feData.pinY !== null;
                    window._allFeOptions.push({
                        value:  feData.id,
                        label:  feData.serial + " - " + feData.location + (pinned ? " (Pinned)" : " (Unpinned)"),
                        pinned: pinned
                    });
                }

                applyFilters();
            }

            // ── Create marker at percentage position ──────────────────────────
            function createMarker(feData, glass) {
                const div = document.createElement("div");
                div.className    = "marker";
                div.dataset.feId = feData.id;
                div.style.left   = (feData.pinX * 100) + "%";
                div.style.top    = (feData.pinY * 100) + "%";

                var isActive = feData.status.toLowerCase().includes("active");
                var colors   = isActive ? MARKER_COLORS.active : MARKER_COLORS.inactive;

                const icon = document.createElement("div");
                icon.className = "marker-icon";
                icon.style.backgroundColor = colors.bg;
                icon.style.border = "1.5px solid " + colors.border;

                const info = document.createElement("div");
                info.className = "marker-info";
                info.innerHTML =
                    "<strong>" + feData.serial + "</strong><br>" +
                    "Type: "     + feData.type     + "<br>" +
                    "Location: " + feData.location + "<br>" +
                    "Expires: "  + feData.expiry   + "<br>" +
                    "Status: <span style='color:" + (isActive ? "green" : "red") + "'>" +
                    feData.status + "</span>";

                div.appendChild(icon);
                div.appendChild(info);
                mapWrapper.appendChild(div);

                div.addEventListener("click", function (e) {
                    if (pinModeActive) return;
                    e.stopPropagation();
                    document.querySelectorAll(".marker.active")
                            .forEach(function (m) { if (m !== div) m.classList.remove("active"); });
                    div.classList.toggle("active");
                });

                div.addEventListener("contextmenu", function (e) {
                    e.preventDefault();
                    e.stopPropagation();

                    contextTarget = "marker";
                    contextMarkerId = feData.id;

                    document.getElementById("modalBtn").style.display = "none";
                    document.getElementById("removeBtn").style.display = "block";

                    const menu = document.querySelector(".map-context-menu");
                    menu.style.left = e.clientX + "px";
                    menu.style.top  = e.clientY + "px";
                    menu.classList.add("visible");
                });


                // Glass is already in DOM — magnify() runs before DOMContentLoaded callbacks.
                var ghost = null;
                if (glass) {
                    ghost = document.createElement("div");
                    ghost.className = "ghost-marker-pin";
                    ghost.style.backgroundColor = colors.bg;
                    ghost.style.border = "1.5px solid " + colors.border;
                    glass.appendChild(ghost);
                }

                window._feMarkers.push({ element: div, data: feData, ghost: ghost });
            }

            function removeMarker(feId) {
                const m = window._feMarkers.find(function (m) { return m.data.id === feId; });
                if (m) {
                    m.element.remove();
                    if (m.ghost && m.ghost.parentElement) m.ghost.remove();
                    window._feMarkers = window._feMarkers.filter(function (x) { return x.data.id !== feId; });
                }
            }

            document.getElementById("removeBtn").addEventListener("click", function (e) {
                    e.stopPropagation();

                    if (!contextMarkerId) return;

                    const feId = contextMarkerId;
                    document.querySelector(".map-context-menu").classList.remove("visible");

                    const formData = new FormData();
                    formData.append("feId", feId);

                    fetch('<%= ResolveUrl("~/Areas/FETS/Pages/MapLayout/RemovePin.ashx") %>', {
                        method: "POST",
                        body: formData
                    })
                    .then(function (r) { if (r.ok) return r.text(); throw new Error("Server error " + r.status); })
                    .then(function (text) {
                        if (text === "ok") {
                            // Remove marker from map
                            removeMarker(feId);

                            // Update _allFeOptions label from (Pinned) to (Unpinned)
                            const entry = window._allFeOptions.find(function(o) { return o.value === feId; });
                            if (entry) {
                                entry.label  = entry.label.replace("(Pinned)", "(Unpinned)");
                                entry.pinned = false;
                            }
                            applyFilters();

                            contextMarkerId = null;
                            alert("Pin removed successfully!");
                        }
                    })
                    .catch(function (err) {
                        alert("Error removing pin: " + err.message);
                    });
                });

            function applyFilters() {
                const filter = document.querySelector('input[name="radio"]:checked').id;

                const filtered = window._allFeOptions.filter(function(opt) {
                    if (filter === "pinnedStatus")   return opt.pinned;
                    if (filter === "unpinnedStatus") return !opt.pinned;
                    return true;
                });

                // Destroy existing Choices instance to avoid duplication
                if (choices) choices.destroy();

                // Rebuild underlying <select> with filtered options
                const sel = document.getElementById("feSelect");
                sel.innerHTML = '<option value="">-- Select Fire Extinguisher --</option>';
                filtered.forEach(function(opt) {
                    const o = document.createElement("option");
                    o.value = opt.value;
                    o.textContent = opt.label;
                    sel.appendChild(o);
                });

                // Reinitialize Choices on clean <select>
                choices = new Choices('#feSelect', {
                    searchEnabled: true,
                    searchPlaceholderValue: 'Search by serial or location...',
                    itemSelectText: '',
                    shouldSort: false
                });
            }

            document.querySelectorAll('input[name="radio"]').forEach(function(radio) {
                radio.addEventListener("change", applyFilters);
            });

            document.getElementById("modalBtn").addEventListener("click", function (e) {
                e.stopPropagation();
                document.querySelector(".map-context-menu").classList.remove("visible");
                document.getElementById("feModal").style.display = "flex";
                console.log("modal display is now:", document.getElementById("feModal").style.display);

            });

            document.getElementById("btnClose").addEventListener("click", function (e) {
                e.stopPropagation();
                document.getElementById("feModal").style.display = "none";
                pendingX = null;
                pendingY = null;
            });

            document.getElementById("btnSave").addEventListener("click", function (e) {
                e.stopPropagation();
                const feId = document.getElementById("feSelect").value;
                if (!feId || pendingX === null || pendingY === null) {
                    alert("Please select a fire extinguisher and click on the map to set its location.");
                    return;
                }
                const formData = new FormData();
                formData.append("feId", feId);
                formData.append("pinX", pendingX);
                formData.append("pinY", pendingY);

                fetch('<%= ResolveUrl("~/Areas/FETS/Pages/MapLayout/SavePin.ashx") %>', {
                    method: "POST",
                    body: formData
                })
                .then(function (r) { if (r.ok) return r.text(); else throw new Error("Network response was not ok"); })
                .then(function (text) {
                    if (text === "ok") {
                        console.log("server responded with:", text);
                        document.getElementById("feModal").style.display = "none";
                        removeMarker(feId);
                        const gridView = document.getElementById("<%= gvFireExtinguishers.ClientID %>");
                        const rows = gridView.getElementsByTagName("tr");
                        for (let i = 1; i < rows.length; i++) {
                            const cells = rows[i].getElementsByTagName("td");
                            if (cells[0].textContent.trim() === feId) {
                                createMarker({
                                    id:       cells[0].textContent.trim(),
                                    serial:   cells[1].textContent.trim(),
                                    location: cells[2].textContent.trim(),
                                    type:     cells[3].textContent.trim(),
                                    expiry:   cells[4].textContent.trim(),
                                    status:   cells[5].textContent.trim(),
                                    pinX:     pendingX,
                                    pinY:     pendingY
                                }, document.querySelector(".map-magnifier-glass"));
                                break;
                            }
                        }
                        // Update _allFeOptions label from (Unpinned) to (Pinned)
                        const entry = window._allFeOptions.find(function(o) { return o.value === feId; });
                        if (entry) {
                            entry.label  = entry.label.replace("(Unpinned)", "(Pinned)");
                            entry.pinned = true;
                        }
                        applyFilters();
                        pendingX = null;
                        pendingY = null;
                        alert("Pin saved successfully!");
                    }
                })
                .catch(function (err) {
                    console.error("Error saving pin:", err);
                    alert("An error occurred while saving the pin. Please try again.");
                });
            })

            document.addEventListener("click", function (e) {
                if (!e.target.closest(".marker")) {
                    document.querySelectorAll(".marker.active")
                            .forEach(function (m) { m.classList.remove("active"); });
                }
            });

            // Wait for image to load before placing markers
            if (mapImage.complete) loadExtinguisherData();
            else mapImage.onload = loadExtinguisherData;
        });
        function getCursorPos(e, element) {
            var a, x = 0, y = 0;
            e = e || window.event;

            a = element.getBoundingClientRect();

            return {x: e.clientX - a.left, y: e.clientY - a.top};
        
        }

        function magnify(imgID, zoom) {
            var img, glass, w, h, bw;
            img = document.getElementById(imgID);

            glass = document.createElement("DIV");
            glass.setAttribute("class", "map-magnifier-glass");

            img.parentElement.insertBefore(glass, img);

            glass.style.backgroundImage = "url('" + img.src + "')";
            glass.style.backgroundRepeat = "no-repeat";
            bw = 3;
            w = glass.offsetWidth / 2;
            h = glass.offsetHeight / 2;

            function applyBackgroundSize() {
                glass.style.backgroundSize = (img.width * zoom) + "px " + (img.height * zoom) + "px";
            }
            // img.width is 0 if image hasn't loaded yet — set now if ready, otherwise wait.
            if (img.complete && img.naturalWidth > 0) {
                applyBackgroundSize();
            } else {
                img.addEventListener("load", applyBackgroundSize);
            }

            glass.addEventListener("mousemove", moveMagnifier);
            img.addEventListener("mousemove", moveMagnifier);

            // Hide all ghost dots when cursor leaves the image/glass
            glass.addEventListener("mouseleave", hideGhosts);
            img.addEventListener("mouseleave", hideGhosts);

            function hideGhosts() {
                window._feMarkers.forEach(function (m) {
                    if (m.ghost) m.ghost.style.display = "none";
                    m.element.style.visibility = "visible";
                });
            }

            // Hold Ctrl to show magnifier; release to hide.
            var magnifierEnabled = false;
            var lastMouseEvent   = null;
            glass.style.display  = "none";

            img.addEventListener("mousemove", function (e) { lastMouseEvent = e; });

            document.addEventListener("keydown", function (e) {
                if (e.key !== "Control" || magnifierEnabled) return;
                magnifierEnabled = true;
                glass.style.display = "";
                if (lastMouseEvent) moveMagnifier(lastMouseEvent);
            });

            document.addEventListener("keyup", function (e) {
                if (e.key !== "Control") return;
                magnifierEnabled = false;
                glass.style.display = "none";
                hideGhosts();
            });

            function moveMagnifier(e) {
                if (!magnifierEnabled) return;
                e.preventDefault();

                var pos = getCursorPos(e, img);
                var x = pos.x;
                var y = pos.y;

                if (x > img.width - (w / zoom)) {x = img.width - (w/zoom);}
                if (x < w / zoom) { x = w /zoom;}
                if (y > img.height - (h / zoom)) {y = img.height - (h/zoom);}
                if (y < h / zoom) { y = h / zoom;}

                glass.style.left = (x - w) + "px";
                glass.style.top = (y - h) + "px";

                glass.style.backgroundPosition = "-" + ((x * zoom) - w + bw) + "px -" + ((y * zoom) - h + bw) + "px";

                // Map each marker's pixel position into glass-space coords and hide/show it.
                // Marker (dx,dy) image-pixels from cursor center → (dx*zoom, dy*zoom) from glass center.
                // hideRadiusSq  — physical glass boundary: hide marker as soon as glass overlaps it
                // ghostRadiusSq — glass interior: show ghost dot only when it won't clip the circular border
                var hideRadiusSq  = w * w * zoom * zoom;
                var ghostRadiusSq = (w - 4) * (w - 4);
                window._feMarkers.forEach(function (m) {
                        var markerPxX = m.data.pinX * img.width;
                        var markerPxY = m.data.pinY * img.height;

                        var relX = (markerPxX - x) * zoom + w;
                        var relY = (markerPxY - y) * zoom + h;

                        var dx = relX - w;
                        var dy = relY - h;
                        var distSq = dx * dx + dy * dy;

                        m.element.style.visibility = distSq < hideRadiusSq ? "hidden" : "visible";

                        if (m.ghost) {
                            var inGlass = distSq < ghostRadiusSq;
                            m.ghost.style.display = inGlass ? "block" : "none";
                            if (inGlass) {
                                m.ghost.style.left = relX + "px";
                                m.ghost.style.top  = relY + "px";
                            }
                        }
                });
            }

        }

        magnify("imgMap", 2);

        
        let pendingX = null;
        let pendingY = null;
        let contextTarget = null;
        let contextMarkerId = null;
        const img = document.getElementById("imgMap");

        document.addEventListener("contextmenu", function (e) {
            if (!e.target.closest(".map-wrapper")) return;
            if (e.target.closest(".marker")) return; // let marker handle it

            e.preventDefault();
            contextTarget = "map";
            contextMarkerId = null;

            document.getElementById("modalBtn").style.display = "block";
            document.getElementById("removeBtn").style.display = "none";

            const menu = document.querySelector(".map-context-menu");
            menu.style.left = e.clientX + "px";
            menu.style.top  = e.clientY + "px";
            const pos = getCursorPos(e, img);
            pendingX = pos.x / img.width;
            pendingY = pos.y / img.height;
            menu.classList.add("visible");
        });

        document.addEventListener("click", function (e) {
            if (e.target.closest(".map-context-menu")) return;
            document.querySelector(".map-context-menu").classList.remove("visible");
        })
    </script>
</body>
</html>
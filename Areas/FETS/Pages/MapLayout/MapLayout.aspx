<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MapLayout.aspx.cs" Inherits="FETS.Pages.MapLayout.MapLayout" MasterPageFile="~/Areas/FETS/Site.Master" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* Base styles to match View Section and Data Entry */
        .dashboard-container {
            padding: 20px;
            max-width: 1200px;
            margin: 0 auto;
            width: 100%;
        }

        .map-layout-section {
            width: 100%;
            max-width: 1100px;
            min-width: 1000px;
            margin: 0 auto;
            background-color: #fff;
            border-radius: 5px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            padding: 30px;
            box-sizing: border-box;
        }

        h3 {
            text-align: center;
            margin: 0 0 30px 0;
            color: #333;
            font-size: 1.75rem;
            font-weight: 600;
            padding-bottom: 15px;
            border-bottom: 2px solid #007bff;
        }

        h4 {
            color: #333;
            font-size: 1.3rem;
            font-weight: 600;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #dee2e6;
        }

        .upload-section {
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #dee2e6;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #333;
            font-weight: 500;
            font-size: 0.95rem;
        }

        .form-control {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 0.95rem;
            min-height: 38px;
        }

        .form-control:focus {
            border-color: #007bff;
            box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
            outline: none;
        }

        .btn-primary {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 8px 16px;
            font-size: 1.2rem;
            min-width: 120px;
            height: auto;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.2s;
        }

        .btn-primary:hover {
            background-color: #0056b3;
        }

        .validation-error {
            color: #dc3545;
            font-size: 0.875rem;
            margin-top: 5px;
            display: block;
        }

        .message {
            padding: 15px;
            margin-top: 20px;
            border-radius: 4px;
            text-align: center;
            font-size: 0.95rem;
        }

        .message.success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .message.error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        /* Filter section styling */
        .filter-section {
            background-color: #f8f9fa;
            border-radius: 5px;
            padding: 15px;
            margin-bottom: 20px;
            border: 1px solid #dee2e6;
        }

        .filter-row {
            display: flex;
            gap: 20px;
            margin-bottom: 15px;
        }

        .filter-group {
            flex: 1;
            min-width: 0;
        }

        /* Grid styling */
        .maps-grid {
            margin-top: 20px;
        }

        .grid-view {
            width: 100%;
            border-collapse: collapse;
            table-layout: fixed;
        }

        .grid-header th {
            background-color: #f8f9fa;
            color: #333;
            font-weight: 600;
            padding: 12px;
            text-align: center;
            border: 1px solid #dee2e6;
        }

        .grid-row td, .grid-row-alt td {
            padding: 10px;
            border: 1px solid #dee2e6;
            text-align: center;
            vertical-align: middle;
        }

        .grid-row-alt {
            background-color: #f8f9fa;
        }

        .grid-row:hover, .grid-row-alt:hover {
            background-color: #f2f2f2;
        }

        .grid-pager {
            text-align: center;
            padding: 10px 0;
            background-color: #f8f9fa;
            border-top: 1px solid #dee2e6;
        }

        .grid-pager a, .grid-pager span {
            padding: 5px 10px;
            margin: 0 2px;
            border: 1px solid #dee2e6;
            border-radius: 3px;
            text-decoration: none;
            color: #007bff;
            background-color: #fff;
            display: inline-block;
            min-width: 32px;
        }

        .grid-pager span {
            background-color: #007bff;
            color: #fff;
            border-color: #007bff;
        }

        .grid-pager a:hover {
            background-color: #e9ecef;
            border-color: #dee2e6;
            color: #0056b3;
        }

        .map-preview {
            max-width: 120px;
            max-height: 80px;
            border: 1px solid #dee2e6;
            border-radius: 4px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        .action-buttons {
            display: flex;
            gap: 5px;
            justify-content: center;
        }

        .btn-sm {
            padding: 4px 8px;
            font-size: 0.875rem;
            min-width: 80px;
        }

        .btn-danger {
            background-color: #dc3545;
            color: white;
            border: none;
        }

        .btn-danger:hover {
            background-color: #c82333;
        }

        .empty-message {
            padding: 20px;
            text-align: center;
            font-size: 1.1em;
            color: #666;
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
        }

        /* Modal Styles */
        .map-modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0, 0, 0, 0.7);
            animation: fadeIn 0.3s;
        }

        .map-modal-content {
            position: relative;
            background-color: #fefefe;
            margin: 3% auto;
            padding: 0;
            border: 1px solid #888;
            width: 90%;
            max-width: 1200px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            animation: slideIn 0.4s;
        }

        .map-modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 20px;
            border-bottom: 1px solid #dee2e6;
            background-color: #f8f9fa;
            border-radius: 8px 8px 0 0;
        }

        .map-modal-header h4 {
            margin: 0;
            color: #333;
            font-size: 1.3rem;
            font-weight: 600;
            border-bottom: none;
            padding-bottom: 0;
        }

        .close-modal {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
            transition: color 0.2s;
        }

        .close-modal:hover,
        .close-modal:focus {
            color: #333;
            text-decoration: none;
        }

        .map-modal-body {
            padding: 20px;
            text-align: center;
        }

        .modal-marker {
            position: absolute;
            width: 8px;
            height: 8px;
            transform: translate(-50%, -50%);
            cursor: default;
            z-index: 10;
        }

        .modal-marker-icon {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            box-shadow: 0 2px 4px rgba(0,0,0,0.3);
        }

        .modal-marker-info {
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
            font-size: 0.82rem;
            line-height: 1.5;
            text-align: left;
            pointer-events: none;
        }

        .modal-marker-info::after {
            content: '';
            position: absolute;
            top: 100%;
            left: 50%;
            transform: translateX(-50%);
            border-width: 8px;
            border-style: solid;
            border-color: white transparent transparent transparent;
        }

        .modal-marker:hover .modal-marker-info {
            display: block;
        }

        .modal-ghost-marker-pin {
            position: absolute;
            width: 8px;
            height: 8px;
            border-radius: 50%;
            transform: translate(-50%, -50%);
            pointer-events: none;
            display: none;
            z-index: 5;
        }

        .modal-magnifier-glass {
            position: absolute;
            border: 3px solid #000;
            border-radius: 50%;
            cursor: none;
            width: 100px;
            height: 100px;
            display: none;
            z-index: 15;
        }

        .modal-magnifier-glass::before,
        .modal-magnifier-glass::after {
            content: '';
            position: absolute;
            background: rgba(0,0,0,0.45);
            pointer-events: none;
        }

        .modal-magnifier-glass::before {
            top: 50%; left: 15%; width: 70%; height: 1px;
            transform: translateY(-50%);
        }

        .modal-magnifier-glass::after {
            left: 50%; top: 15%; height: 70%; width: 1px;
            transform: translateX(-50%);
        }

        .full-screen-map {
            max-width: 100%;
            max-height: 80vh;
            border: 1px solid #dee2e6;
            border-radius: 4px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        @keyframes fadeIn {
            from {opacity: 0}
            to {opacity: 1}
        }

        @keyframes slideIn {
            from {transform: translateY(-50px); opacity: 0;}
            to {transform: translateY(0); opacity: 1;}
        }

        /* Responsive styles */
        @media (max-width: 1200px) {
            .map-layout-section {
                min-width: auto;
                width: 100%;
                padding: 20px;
            }

            .filter-row {
                flex-direction: column;
                gap: 10px;
            }
        }

        /* Simplified file upload button styling */
        .custom-file-upload .file-upload-btn {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 4px;
            font-size: 0.9rem;
            font-weight: 500;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s ease;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            width: auto;
            min-width: 150px;
            margin-bottom: 10px;
        }

        .custom-file-upload .file-upload-btn:hover {
            background-color: #0056b3;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.15);
            transform: translateY(-1px);
        }

        .custom-file-upload {
            position: relative;
            overflow: hidden;
            margin-top: 10px;
            display: flex;
            flex-direction: column;
            align-items: flex-start;
            width: 100%;
        }

        .custom-file-upload .file-upload-btn i {
            margin-right: 6px;
            font-size: 1rem;
        }

        .custom-file-upload input[type="file"] {
            position: absolute;
            left: 0;
            top: 0;
            opacity: 0;
            width: 100%;
            height: 100%;
            cursor: pointer;
        }

        .file-name-display {
            margin-top: 10px;
            padding: 10px 15px;
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 4px;
            font-size: 0.95rem;
            color: #495057;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            display: none;
        }

        .file-name-display.has-file {
            display: flex;
            align-items: center;
        }

        .file-name-display i {
            margin-right: 10px;
            color: #28a745;
            font-size: 1.1rem;
        }

        /* Image preview styling with delete button */
        .image-preview-container {
            margin-top: 15px;
            padding: 15px;
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 4px;
            display: none;
            text-align: center;
        }

        .preview-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
            padding-bottom: 8px;
            border-bottom: 1px solid #dee2e6;
        }

        .preview-header h5 {
            margin: 0;
            color: #333;
            font-size: 1rem;
            font-weight: 500;
        }

        .btn-delete-image {
            background-color: #dc3545;
            color: white;
            border: none;
            border-radius: 4px;
            padding: 5px 10px;
            font-size: 0.85rem;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            transition: background-color 0.2s;
        }

        .btn-delete-image:hover {
            background-color: #c82333;
        }

        .btn-delete-image i {
            margin-right: 5px;
            font-size: 0.9rem;
        }

        .image-preview {
            max-width: 100%;
            max-height: 300px;
            border: 1px solid #dee2e6;
            border-radius: 4px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        /* Add Font Awesome for icons */
        @import url('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css');
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="dashboard-container">
        <div class="map-layout-section">
            <h3>Map Layout</h3>
            
            <div class="upload-section">
                <h4>Upload New Map</h4>
                <div class="form-group">
                    <asp:Label ID="lblPlant" runat="server" Text="Plant:" AssociatedControlID="ddlPlant"></asp:Label>
                    <asp:DropDownList ID="ddlPlant" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlPlant_SelectedIndexChanged" CausesValidation="false"></asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvPlant" runat="server" 
                        ControlToValidate="ddlPlant" 
                        ErrorMessage="Plant is required." 
                        CssClass="validation-error"
                        Display="Dynamic"
                        ValidationGroup="UploadMap"
                        InitialValue="">
                    </asp:RequiredFieldValidator>
                </div>

                <div class="form-group">
                    <asp:Label ID="lblLevel" runat="server" Text="Level:" AssociatedControlID="ddlLevel"></asp:Label>
                    <asp:DropDownList ID="ddlLevel" runat="server" CssClass="form-control"></asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvLevel" runat="server" 
                        ControlToValidate="ddlLevel" 
                        ErrorMessage="Level is required." 
                        CssClass="validation-error"
                        Display="Dynamic"
                        ValidationGroup="UploadMap"
                        InitialValue="">
                    </asp:RequiredFieldValidator>
                </div>

                <div class="form-group">
                    <asp:Label ID="lblMapFile" runat="server" Text="Map Image:" AssociatedControlID="fuMapImage"></asp:Label>
                    <div class="custom-file-upload">
                        <div class="file-upload-btn">
                            <i class="fas fa-upload"></i> Select Image
                        </div>
                        <asp:FileUpload ID="fuMapImage" runat="server" CssClass="form-control" onchange="updateFileName(this)" />
                        <div id="fileNameDisplay" class="file-name-display">
                            <i class="fas fa-file-image"></i>
                            <span id="fileName">No file chosen</span>
                        </div>
                    </div>
                    <div id="imagePreviewContainer" class="image-preview-container">
                        <div class="preview-header">
                            <h5>Map Preview</h5>
                            <button type="button" id="btnDeleteImage" class="btn-delete-image" onclick="deleteImage()">
                                <i class="fas fa-times"></i> Remove
                            </button>
                        </div>
                        <img id="imagePreview" class="image-preview" src="" alt="Preview" />
                    </div>
                    <asp:RequiredFieldValidator ID="rfvMapImage" runat="server" 
                        ControlToValidate="fuMapImage" 
                        ErrorMessage="Map image is required." 
                        CssClass="validation-error"
                        Display="Dynamic"
                        ValidationGroup="UploadMap">
                    </asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revMapImage" runat="server"
                        ControlToValidate="fuMapImage"
                        ErrorMessage="Only image files (jpg, jpeg, png) are allowed."
                        ValidationExpression="^.*\.(jpg|jpeg|png|JPG|JPEG|PNG)$"
                        CssClass="validation-error"
                        Display="Dynamic"
                        ValidationGroup="UploadMap">
                    </asp:RegularExpressionValidator>
                </div>

                <div class="form-group">
                    <asp:Button ID="btnUpload" runat="server" Text="Upload Map" OnClick="btnUpload_Click" CssClass="btn btn-primary" ValidationGroup="UploadMap" />
                </div>

                <asp:Label ID="lblMessage" runat="server" CssClass="message"></asp:Label>
            </div>

            <div class="view-maps-section">
                <h4>View Maps</h4>
                <div class="filter-section">
                    <div class="filter-row">
                        <div class="filter-group">
                            <asp:Label ID="lblFilterPlant" runat="server" Text="Plant:" AssociatedControlID="ddlFilterPlant"></asp:Label>
                            <asp:DropDownList ID="ddlFilterPlant" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlFilterPlant_SelectedIndexChanged"></asp:DropDownList>
                        </div>
                        <div class="filter-group">
                            <asp:Label ID="lblFilterLevel" runat="server" Text="Level:" AssociatedControlID="ddlFilterLevel"></asp:Label>
                            <asp:DropDownList ID="ddlFilterLevel" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlFilterLevel_SelectedIndexChanged"></asp:DropDownList>
                        </div>
                    </div>
                </div>

                <div class="maps-grid">
                    <asp:GridView ID="gvMaps" runat="server" 
                        AutoGenerateColumns="False" 
                        CssClass="grid-view"
                        AllowPaging="True"
                        PageSize="5"
                        OnPageIndexChanging="gvMaps_PageIndexChanging"
                        OnRowCommand="gvMaps_RowCommand">
                        <Columns>
                            <asp:BoundField DataField="PlantName" HeaderText="Plant" />
                            <asp:BoundField DataField="LevelName" HeaderText="Level" />
                            <asp:BoundField DataField="UploadDate" HeaderText="Upload Date" DataFormatString="{0:d}" />
                            <asp:TemplateField HeaderText="Preview">
                                <ItemTemplate>
                                    <asp:Image ID="imgPreview" runat="server" ImageUrl='<%# GetMapImageUrl(Eval("ImagePath").ToString()) %>' CssClass="map-preview" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <div class="action-buttons">
                                        <button type="button"
                                            class="btn btn-sm btn-primary"
                                            data-image-url='<%# ResolveUrl("~/Uploads/Maps/" + Eval("ImagePath").ToString()) %>'
                                            data-plant-name='<%# Eval("PlantName") %>'
                                            data-level-name='<%# Eval("LevelName") %>'
                                            data-plant-id='<%# Eval("PlantID") %>'
                                            data-level-id='<%# Eval("LevelID") %>'
                                            onclick="openMapFromButton(this)">View</button>
                                        <asp:LinkButton ID="btnDelete" runat="server" 
                                            CommandName="DeleteMap" 
                                            CommandArgument='<%# Eval("MapID") %>'
                                            CssClass="btn btn-sm btn-danger"
                                            Text="Delete"
                                            OnClientClick="return confirm('Are you sure you want to delete this map?');" />
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <PagerStyle CssClass="grid-pager" />
                        <HeaderStyle CssClass="grid-header" />
                        <RowStyle CssClass="grid-row" />
                        <AlternatingRowStyle CssClass="grid-row-alt" />
                        <EmptyDataTemplate>
                            <div class="empty-message">No maps found.</div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>

    <!-- Full Screen Map Modal -->
    <div id="mapModal" class="map-modal">
        <div class="map-modal-content">
            <div class="map-modal-header">
                <h4 id="mapModalTitle">Map View</h4>
                <span class="close-modal" onclick="closeMapModal()">&times;</span>
            </div>
            <div class="map-modal-body">
                <div id="modalMapWrapper" style="position:relative; display:inline-block;">
                    <img id="fullScreenMap" class="full-screen-map" src="" alt="Floor Map" />
                    <div id="modalMarkersContainer"></div>
                </div>
            </div>
            <div class="map-modal-footer" style="padding: 12px 20px; border-top: 1px solid #dee2e6; text-align: right; background: #f8f9fa; border-radius: 0 0 8px 8px;">
                <a id="btnOpenFullView" href="#" target="_blank"
                   style="padding: 8px 16px; background: #007bff; color: white; border-radius: 4px; text-decoration: none; font-size: 0.9rem;">
                    Open Full View (Pin Mode)
                </a>
            </div>
        </div>
    </div>

    <div id="feEditModal" style="display:none; position:fixed; z-index:2000; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,0.6);">
        <div style="background:white; margin:8% auto; padding:0; width:420px; border-radius:8px; box-shadow:0 4px 16px rgba(0,0,0,0.3);">
            <div style="padding:14px 20px; border-bottom:1px solid #dee2e6; display:flex; justify-content:space-betweem; align-items:center;">
                <strong>Edit Fire Extinguisher</strong>
                <span onclick="closeEditModal()" style="cursor:pointer; font-size:1.4rem; color:#aaa">&times;</span>
            </div>

            <div style="padding:20px;">
                <input type="hidden" id="editFEID" />

                <div class="form-group">
                    <label>Serial Number</label>
                    <input type="text" id="editSerial" class="form-control" />
                </div>
                <div class="form-group">
                    <label>Location</label>
                    <input type="text" id="editLocation" class="form-control" />
                </div>
                <div class="form-group">
                    <label>Type</label>
                    <select id="editType" class="form-control"></select>
                </div>
                <div class="form-group">
                    <label>Expiry Date</label>
                    <input type="date" id="editExpiry" class="form-control" />
                </div>
                <div class="form-group">
                    <label>Status</label>
                    <select id="editStatus" class="form-control"></select>
                </div>
            </div>

            <div style="padding:12px 20px; border-top:1px solid #dee2e6; text-align:right; background:#f8f9fa; border-radius:0 0 8px 8px;">
                <span id="editSaveStatus" style="font-size:0.85rem; margin-right:10px;"></span>
                <button type="button" onclick="closeEditModal()" style="padding:6px 14px; margin-right:8px; border:1px solid #ccc; background:white; border-radius:4px; cursor:pointer;">
                    Cancel
                </button>
                <button type="button" onclick="saveEditedFE()" style="padding:6px 14px; background:#007bff; color:white; border:none; border-radius:4px; cursor:pointer;">
                    Save
                </button>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        var feTypes = <%= TypesJson %>;
        var feStatuses = <%= StatusesJson %>;

        function updateFileName(input) {
            var fileNameDisplay = document.getElementById('fileNameDisplay');
            var fileNameSpan = document.getElementById('fileName');
            var imagePreview = document.getElementById('imagePreview');
            var previewContainer = document.getElementById('imagePreviewContainer');
            
            if (input.files && input.files[0]) {
                // Update file name
                var fileName = input.files[0].name;
                fileNameSpan.textContent = fileName;
                fileNameDisplay.classList.add('has-file');
                
                // Show image preview
                var reader = new FileReader();
                reader.onload = function(e) {
                    imagePreview.src = e.target.result;
                    previewContainer.style.display = 'block';
                };
                reader.readAsDataURL(input.files[0]);
            } else {
                // Reset file name
                fileNameSpan.textContent = 'No file chosen';
                fileNameDisplay.classList.remove('has-file');
                
                // Hide image preview
                previewContainer.style.display = 'none';
                imagePreview.src = '';
            }
        }
        
        function deleteImage() {
            // Clear the file input
            var fileInput = document.getElementById('<%= fuMapImage.ClientID %>');
            fileInput.value = '';
            
            // Reset file name display
            var fileNameDisplay = document.getElementById('fileNameDisplay');
            var fileNameSpan = document.getElementById('fileName');
            fileNameSpan.textContent = 'No file chosen';
            fileNameDisplay.classList.remove('has-file');
            
            // Hide image preview
            var imagePreview = document.getElementById('imagePreview');
            var previewContainer = document.getElementById('imagePreviewContainer');
            previewContainer.style.display = 'none';
            imagePreview.src = '';
            
            // Prevent the form from submitting
            return false;
        }

        // Modal functions
        function openMapFromButton(btn) {
            openMapModal(
                btn.getAttribute('data-image-url'),
                btn.getAttribute('data-plant-name'),
                btn.getAttribute('data-level-name'),
                btn.getAttribute('data-plant-id'),
                btn.getAttribute('data-level-id')
            );
        }

        function openMapModal(imageUrl, plantName, levelName, plantId, levelId) {
            var modal = document.getElementById('mapModal');
            var fullScreenMap = document.getElementById('fullScreenMap');
            var modalTitle = document.getElementById('mapModalTitle');
            var btnFullView = document.getElementById('btnOpenFullView');

            // Set image and title
            fullScreenMap.src = imageUrl;
            modalTitle.innerText = plantName + ' - ' + levelName + ' Map';

            // Set "Open Full View" link with PlantID + LevelID
            btnFullView.href = '<%= ResolveUrl("~/Areas/FETS/Pages/MapLayout/ViewMap.aspx") %>?PlantID=' + plantId + '&LevelID=' + levelId;
            
            // Load Fire Extinguisher pins
            document.getElementById('modalMarkersContainer').innerHTML = '';
            fullScreenMap.onload = function () {
                loadModalPins(plantId, levelId);
            };

            if (fullScreenMap.complete && fullScreenMap.naturalWidth > 0) {
                loadModalPins(plantId, levelId);
            }

            // Show modal
            modal.style.display = 'block';
            document.body.style.overflow = 'hidden';
            document.addEventListener('keydown', closeModalOnEscape);
        }
        
        function closeMapModal() {
            var modal = document.getElementById('mapModal');
            modal.style.display = 'none';
            document.body.style.overflow = 'auto';
            document.removeEventListener('keydown', closeModalOnEscape);

            document.getElementById('modalMarkersContainer').innerHTML = '';
            _modalMarkers = [];
            _modalMagnifierEnabled = false;
            if (_modalGlass && _modalGlass.parentElement) {
                _modalGlass.remove();
                _modalGlass = null;
            }
        }
        
        function closeModalOnEscape(e) {
            if (e.key === 'Escape') {
                closeMapModal();
            }
        }
        
        // Close modal when clicking outside of it
        window.onclick = function(event) {
            var modal = document.getElementById('mapModal');
            if (event.target == modal) {
                closeMapModal();
            }
        }

        var _modalMarkers = [];
        var _modalGlass = null;
        var _modalMagnifierEnabled = false;
        var _modalLastMouseEvent = null;

        var MODAL_MARKER_COLORS = {
            active:   { bg: '#27ae60', border: '#1e8449' },
            inactive: { bg: '#e74c3c', border: '#c0392b' }
        };

        function loadModalPins(plantId, levelId) {
            var img = document.getElementById('fullScreenMap');
            var container = document.getElementById('modalMarkersContainer');
            container.innerHTML = '';
            _modalMarkers = [];

            if (_modalGlass && _modalGlass.parentElement) {
                _modalGlass.remove();
                _modalGlass = null;
            }

            _modalGlass = document.createElement('div');
            _modalGlass.className = 'modal-magnifier-glass';
            img.parentElement.insertBefore(_modalGlass, img);

            var zoom = 2, bw = 3;
            var w = 50, h = 50; // glass radius (100px / 2)

            function applyGlassBg() {
                _modalGlass.style.backgroundImage = "url('" + img.src + "')";
                _modalGlass.style.backgroundRepeat = 'no-repeat';
                _modalGlass.style.backgroundSize = (img.width * zoom) + 'px ' + (img.height * zoom) + 'px';
            }
            if (img.complete && img.naturalWidth > 0) applyGlassBg();
            else img.addEventListener('load', applyGlassBg);

            function moveMagnifier(e) {
                if (!_modalMagnifierEnabled) return;
                e.preventDefault();
                var rect = img.getBoundingClientRect();
                var x = e.clientX - rect.left;
                var y = e.clientY - rect.top;

                if (x > img.width - w / zoom) x = img.width - w / zoom;
                if (x < w / zoom) x = w / zoom;
                if (y > img.height - h / zoom) y = img.height - h / zoom;
                if (y < h / zoom) y = h / zoom;

                _modalGlass.style.left = (x - w) + 'px';
                _modalGlass.style.top  = (y - h) + 'px';
                _modalGlass.style.backgroundPosition = '-' + ((x * zoom) - w + bw) + 'px -' + ((y * zoom) - h + bw) + 'px';

                var hideRadiusSq  = w * w * zoom * zoom;
                var ghostRadiusSq = (w - 4) * (w - 4);
                _modalMarkers.forEach(function(m) {
                    var px = m.data.pinX * img.width;
                    var py = m.data.pinY * img.height;
                    var relX = (px - x) * zoom + w;
                    var relY = (py - y) * zoom + h;
                    var dx = relX - w, dy = relY - h;
                    var distSq = dx * dx + dy * dy;
                    m.element.style.visibility = distSq < hideRadiusSq ? 'hidden' : 'visible';
                    if (m.ghost) {
                        var inGlass = distSq < ghostRadiusSq;
                        m.ghost.style.display = inGlass ? 'block' : 'none';
                        if (inGlass) { m.ghost.style.left = relX + 'px'; m.ghost.style.top = relY + 'px'; }
                    }
                });
            }

            function hideModalGhosts() {
                _modalMarkers.forEach(function(m) {
                    if (m.ghost) m.ghost.style.display = 'none';
                    m.element.style.visibility = 'visible';
                });
            }

            img.addEventListener('mousemove', function(e) { _modalLastMouseEvent = e; moveMagnifier(e); });
            _modalGlass.addEventListener('mousemove', moveMagnifier);
            _modalGlass.addEventListener('mouseleave', hideModalGhosts);
            img.addEventListener('mouseleave', hideModalGhosts);

            var url = '<%= ResolveUrl("~/Areas/FETS/Pages/MapLayout/GetPins.ashx") %>' + '?PlantID=' + plantId + '&LevelID=' + levelId;
            fetch(url)
                .then(function(r) { if (!r.ok) throw new Error('Status ' + r.status); return r.json(); })
                .then(function(pins) {
                    pins.forEach(function(pin) {
                        var isActive = pin.status.toLowerCase().includes('active');
                        var colors   = isActive ? MODAL_MARKER_COLORS.active : MODAL_MARKER_COLORS.inactive;

                        var marker = document.createElement('div');
                        marker.className  = 'modal-marker';
                        marker.style.left = (pin.pinX * 100) + '%';
                        marker.style.top  = (pin.pinY * 100) + '%';

                        var icon = document.createElement('div');
                        icon.className = 'modal-marker-icon';
                        icon.style.backgroundColor = colors.bg;
                        icon.style.border = '1.5px solid ' + colors.border;

                        var info = document.createElement('div');
                        info.className = 'modal-marker-info';
                        info.innerHTML =
                            '<strong>' + pin.serial + '</strong><br>' +
                            'Type: ' + pin.type + '<br>' +
                            'Location: ' + pin.location + '<br>' +
                            'Expires: ' + (pin.expiry || 'N/A') + '<br>' +
                            'Status: <span style="color:' + (isActive ? 'green' : 'red') + '">' + pin.status + '</span>';

                        marker.appendChild(icon);
                        marker.appendChild(info);
                        container.appendChild(marker);

                        marker.addEventListener('click', function(e) {
                            e.stopPropagation();
                            openEditModal(pin);
                        });

                        var ghost = document.createElement('div');
                        ghost.className = 'modal-ghost-marker-pin';
                        ghost.style.backgroundColor = colors.bg;
                        ghost.style.border = '1.5px solid ' + colors.border;
                        _modalGlass.appendChild(ghost);

                        _modalMarkers.push({ element: marker, data: pin, ghost: ghost });
                    });
                })
                .catch(function(err) { console.error('GetPins failed:', err); });
        }

        document.addEventListener('keydown', function(e) {
            if (e.key !== 'Control' || !_modalGlass) return;
            _modalMagnifierEnabled = true;
            _modalGlass.style.display = 'block';
        });
        document.addEventListener('keyup', function(e) {
            if (e.key !== 'Control') return;
            _modalMagnifierEnabled = false;
            if (_modalGlass) _modalGlass.style.display = 'none';
        });

        function openEditModal(pin)
        {
            document.getElementById('editFEID').value = pin.feId;
            document.getElementById('editSerial').value = pin.serial;
            document.getElementById('editLocation').value = pin.location;
            document.getElementById('editExpiry').value = pin.expiry || '';

            var typeSelect = document.getElementById('editType');
            typeSelect.innerHTML = '';
            feTypes.forEach(function (t) {
                var opt = document.createElement('option');
                opt.value = t.id;
                opt.textContent = t.name;
                if (t.name === pin.type) opt.selected = true;
                typeSelect.appendChild(opt);
            });

            var statusSelect = document.getElementById('editStatus');
            statusSelect.innerHTML = '';
            feStatuses.forEach(function (s) {
                var opt = document.createElement('option');
                opt.value = s.id;
                opt.textContent = s.name;
                if (s.name === pin.status) opt.selected = true;
                statusSelect.appendChild(opt);
            });

            document.getElementById('editSaveStatus').textContent = '';
            document.getElementById('feEditModal').style.display = 'block';
        }

        function closeEditModal() {
            document.getElementById('feEditModal').style.display = 'none';
        }

        function saveEditedFE() {
            var feId = document.getElementById('editFEID').value;
            var serial = document.getElementById('editSerial').value;
            var location = document.getElementById('editLocation').value;
            var typeId = document.getElementById('editType').value;
            var expiry = document.getElementById('editExpiry').value;
            var statusId = document.getElementById('editStatus').value;

            if (!serial || !location) {
                document.getElementById('editSaveStatus').textContent = 'Serial and Location are required.';
                return;
            }

            var status = document.getElementById('editSaveStatus');
            status.textContent = 'Saving ...';

            var formData = new FormData();
            formData.append('feid', feId);
            formData.append('serial', serial);
            formData.append('location', location);
            formData.append('typeId', typeId);
            formData.append('expiry', expiry);
            formData.append('statusId', statusId);

            fetch('<%= ResolveUrl("~/Areas/FETS/Pages/MapLayout/UpdateFE.ashx") %>', {
                method: 'POST',
                body: formData
            })
            .then(function (r) {
                if (r.ok)
                    return r.text();
                throw new Error('Status ' + r.status);
            })
            .then(function (text) {
                if (text === 'ok') {
                    status.textContent = 'Saved!';
                    setTimeout(closeEditModal, 1000);
                } else {
                    status.textContent = 'Failed! ' + text;
                }
            })
            .catch(function (err) {
                status.textContent = 'Error: ' + err.message;
            });
        }

        // Fallback for browsers that don't support our modal
        // This will redirect to a full page view if needed
        function fallbackToFullPage(plantId, levelId) {
            window.location.href = '<%=ResolveUrl("~/Pages/MapLayout/ViewMap.aspx")%>?PlantID=' + plantId + '&LevelID=' + levelId;
        }
    </script>
</asp:Content> 
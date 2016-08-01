<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ChatTest.aspx.cs" Inherits="SignalRTextChat.ChatTest" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!DOCTYPE html>
    <html>
        <input type="button" id="test" value="Test" />
        <input type="hidden" id="roomname" />

        <script src="Scripts/jquery-1.10.2.min.js"></script>
        <script type="text/javascript">
            $(function () {
                $('#test').click(function () {
                    $('#roomname').val(prompt('Enter room name here:', ''))
                    var roomname = $('#roomname').val();
                    localStorage.room = roomname;
                    window.open('Chat1.aspx');
                });
            });
        </script>
    </html>
</asp:Content>

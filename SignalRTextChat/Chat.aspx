﻿<%@ Page Title="Chat" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Chat.aspx.cs" Inherits="SignalRTextChat.Chat" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!DOCTYPE html>
<html>  
    <title>SignalR Simple Chat</title>
    <style type="text/css">
        .box {
            background-color: #99CCFF;
            border: thick solid #808080;
            padding: 20px;
            margin: 20px;
        }
    </style>
    <div class="box">
        <input type="text" id="roomname" placeholder="Enter room name here" />
        <input type="button" id="enterroom" value="Enter" />
        <input type="button" id="leaveroom" value="Leave" disabled />
        <input type="text" id="message" placeholder="Enter message here" />
        <input type="button" id="sendmessage" value="Send" />
        <input type="hidden" id="displayname" />
        <ul id="discussion"></ul>
    </div>
    <!--Script references. -->
    <!--Reference the jQuery library. -->
    <script src="Scripts/jquery-1.10.2.min.js"></script>
    <!--Reference the SignalR library. -->
    <script src="Scripts/jquery.signalR-2.2.1.min.js"></script>
    <!--Reference the autogenerated SignalR hub script. -->
    <script src="signalr/hubs"></script>
    <!--Add script to update the page and send messages.-->
    <script type="text/javascript">
        $(function () {
            // Declare a proxy to reference the hub.
            var chat = $.connection.chatHub;
            // Create a function that the hub can call to broadcast messages.
            chat.client.broadcastMessage = function (name, message, roomname) {
                // Html encode display name and message.
                var encodedName = $('<div />').text(name).html();
                var encodedMsg = $('<div />').text(message).html();
                // Add the message to the page.
                $('#discussion').append('<li><strong>' + encodedName
                    + '</strong>:&nbsp;&nbsp;' + encodedMsg + '</li>');
            };
            chat.client.addMessage = function (name, message, roomname) {
                // Html encode display name and message.
                var encodedName = $('<div />').text(name).html();
                var encodedMsg = $('<div />').text(message).html();
                // Add the message to the page.
                $('#discussion').append('<li><strong>' + encodedName
                    + '</strong>:&nbsp;&nbsp;' + encodedMsg + '</li>');
            };
            // Get the user name and store it to prepend to messages.
            $('#displayname').val(prompt('Enter your name:', ''));
            // Set initial focus to message input box.
            $('#message').focus();
            // Start the connection
            $.connection.hub.start().done(function () {
                $('#enterroom').click(function () {
                    //Call the JoinRoom method on the hub
                    if ($('#roomname').val() === "") {
                        chat.server.joinRoom("Global");
                    }
                    else {
                        chat.server.joinRoom($('#roomname').val());
                    }
                    enterroom.disabled = true;
                    leaveroom.disabled = false;
                });
                $('#sendmessage').click(function () {                    
                    // Call the Send method on the hub.
                    chat.server.send($('#displayname').val(), $('#message').val(), $('#roomname').val());
                    // Clear text box and reset focus for next comment.
                    $('#message').val('').focus();                    
                });
                $('#leaveroom').click(function () {
                    chat.server.leaveRoom($('#roomname').val());
                    $('#roomname').val('');
                    enterroom.disabled = false;
                    leaveroom.disabled = true;
                });
            });
        });
    </script>
</html>
</asp:Content>

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
            text-align:justify;
        }
        .box ul {
            list-style-type:none;
            border: 1px solid black;
            margin-top:20px;
        }
        .box #message {
            margin-top:20px;
            width:inherit;
        }
    </style>
    <div class="box">
        <input type="text" id="roomname" placeholder="Enter room name here" />
        <input type="button" id="enterroom" value="Enter" />
        <input type="button" id="leaveroom" value="Leave" disabled />
        <br />
        <input type="text" id="message" placeholder="Enter message here" />
        <input type="button" id="sendmessage" value="Send" />
        <input type="hidden" id="displayname" />
        <ul id="discussion"></ul>
    </div>

    <div>
        <p>Number of online users</p>
        <p id="usersCount"></p>
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
                var encodeRoomName = $('<div />').text(roomname).html();
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

            chat.client.updateUsersOnlineCount = function (count) {
                $('#usersCount').text(count);
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
                        //Clients will join a room called Global when the RoomName is null
                        chat.server.joinRoom("Global");
                        $('#discussion').append('<li><strong>You joined the Global Chat Room</strong></li>')
                    }
                    else {
                        chat.server.joinRoom($('#roomname').val());
                        var _roomname = $('#roomname').val();
                        $('#discussion').append('<li><strong>You joined the ' + _roomname + ' Chat Room</strong></li>');
                    }
                    $('#message').val('').focus();
                    enterroom.disabled = true;
                    leaveroom.disabled = false;
                    roomname.disabled = true;
                });
                $('#sendmessage').click(function () {
                    if ($('#message').val() === "") {
                        //Don't allow them to spam empty messages
                    }
                    else {
                        // Call the Send method on the hub.
                        chat.server.send($('#displayname').val(), $('#message').val(), $('#roomname').val());
                        // Clear text box and reset focus for next comment.
                        $('#message').val('').focus();
                    }                   
                });
                $(document).keydown(function (e) {
                    if (e.which == 13 || e.keyCode == 13) {
                        if ($('#message').val() === "") {
                            //Don't allow them to spam empty messages
                        }
                        else {
                            // Call the Send method on the hub.
                            chat.server.send($('#displayname').val(), $('#message').val(), $('#roomname').val());
                            // Clear text box and reset focus for next comment.
                            $('#message').val('').focus();
                        }
                    }
                });
                $('#leaveroom').click(function () {
                    //Call the LeaveRoom method on the hub
                    chat.server.leaveRoom($('#roomname').val());
                    $('#discussion').append('<li><strong>You left the room</strong></li>')
                    $('#roomname').val('').focus();
                    enterroom.disabled = false;
                    leaveroom.disabled = true;
                    roomname.disabled = false;
                });
            });
        });
    </script>
</html>
</asp:Content>

<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Chat1.aspx.cs" Inherits="SignalRTextChat.Chat1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!DOCTYPE html>
    <html>
        <style type="text/css">
            #box {
            background-color: #99CCFF;
            border: thick solid #808080;
            padding: 20px;
            margin: 20px;
            text-align:justify;
            max-width:none;
            }
            #entermessage {
                max-width:none;
                width:85%;
            }
            #discussion {
                list-style-type:none;
                margin-top:20px;
                height:200px;
                max-height:200px;
                overflow-y:auto;
                overflow-x:auto;
            }
            p input {
                margin:5px;
            }
            #online {
                float:none;
                text-align:justify;
            }
        </style>

        <div id="box">
            <p id="getroom" style="display:inline;"></p>
            <ul id="discussion"></ul>
            <p>Message:<input type="text" id="entermessage" placeholder="Enter message here" /><input type="button" value="Send" id="sendmessage" /></p>
            <input type="hidden" id="displayname" />

            <div id="online">
                <p>Number of Online Users</p>
                <p id="usersCount"></p>
            </div>
        </div>
        
        <script src="Scripts/jquery-1.10.2.min.js"></script>
        <script src="Scripts/jquery.signalR-2.2.1.min.js"></script>
        <script src="signalr/hubs"></script>

        <script type="text/javascript">
            $(function () {
                var chat = $.connection.chatHub;

                chat.client.addChatMessage = function (name, message, roomname) {
                    var encodedName = $("<div />").text(name).html();
                    var encodedMsg = $("<div />").text(message).html();
                    var encodedRoom = $("<div />").text(roomname).html();

                    $('#discussion').append('<li><strong>' + encodedName + '</strong>:&nbsp;&nbsp;' + encodedMsg + '<li>');\
                    //Method to automatically scroll down to the bottom of the chat box message
                    $('#discussion').animate({ scrollTop: $('#discussion').prop("scrollHeight") }, 500);
                };

                chat.client.updateUsersOnlineCount = function (count) {
                    $('#usersCount').text(count);
                };

                $('#displayname').val(prompt('Please enter your name:', ''));
                $('#discussion').append('<li style="color:red;"><strong> Welcome ' + $('#displayname').val() + '!');
                $('#entermessage').focus();

                $.connection.hub.start().done(function () {
                    $('#getroom').text(localStorage.room);
                    $('#getroom').append('<input type="button" id="leave" value="Leave" />');
                    chat.server.joinRoom($('#getroom').text());

                    $('#entermessage').val('').focus();

                    $('#sendmessage').click(function () {
                        if ($('#entermessage').val() === "") {

                        }
                        else {
                            chat.server.send($('#displayname').val(), $('#entermessage').val(), $('#getroom').text());
                            $('#entermessage').val('').focus;
                        }
                    });
                    $(document).keydown(function (e) {
                        if (e.which == 13 || e.keyCode == 13) {
                            if ($('#entermessage').val() === "") {
                                //Don't allow them to spam empty messages
                            }
                            else {
                                // Call the Send method on the hub.
                                chat.server.send($('#displayname').val(), $('#entermessage').val(), $('#getroom').text());
                                // Clear text box and reset focus for next comment.
                                $('#entermessage').val('').focus();
                            }
                            e.preventDefault();
                        }
                    });
                    $('#leave').click(function () {
                        chat.server.leaveRoom($('#getroom').text());
                        window.close();
                    });
                });
            });
        </script>
        </html>
</asp:Content>

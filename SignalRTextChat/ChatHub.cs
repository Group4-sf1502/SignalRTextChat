﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.AspNet.SignalR;

namespace SignalRTextChat
{
    public class ChatHub : Hub
    {
        public void Send(string name, string message, string roomname)
        {
            try
            {
                Clients.Group(roomname).addMessage(name, message);
            }
            catch(Exception e)
            {
                Clients.All.broadcastMessage(name, message);
            }
            
        }

        public void JoinRoom(string roomname)
        {
            Groups.Add(Context.ConnectionId, roomname);
        }

        public void LeaveRoom(string roomname)
        {
            Groups.Remove(Context.ConnectionId, roomname);
        }
    }
}
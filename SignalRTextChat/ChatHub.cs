﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.AspNet.SignalR;
using System.Threading.Tasks;

namespace SignalRTextChat
{
    public class ChatHub : Hub
    {
        //public static string username = getUsername();
        public static List<string> Users = new List<string>();

        public void Send(string name, string message, string roomname)
        {
            if (roomname != "")
            {
                Clients.Group(roomname).addChatMessage(name, message);
            }
            else
            {
                Clients.Group("Global").addChatMessage(name, message);
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

        public void Count(int count)
        {
            var context = GlobalHost.ConnectionManager.GetHubContext<ChatHub>();
            context.Clients.All.updateUsersOnlineCount(count);
        }

        public override Task OnConnected()
        {
            string clientId = GetClientId();

            if (Users.IndexOf(clientId) == -1)
            {
                Users.Add(clientId);
            }

            // Send the current count of users
            Count(Users.Count);

            return base.OnConnected();
        }

        public override Task OnDisconnected(bool stopCalled)
        {
            string clientId = GetClientId();

            if (Users.IndexOf(clientId) > -1)
            {
                Users.Remove(clientId);
            }

            // Send the current count of users
            Count(Users.Count);

            return base.OnDisconnected(stopCalled);
        }

        private string GetClientId()
        {
            string clientId = "";
            if (Context.QueryString["clientId"] != null)
            {
                clientId = this.Context.QueryString["clientId"];
            }

            if (string.IsNullOrEmpty(clientId.Trim()))
            {
                clientId = Context.ConnectionId;
            }

            return clientId;
        }

        private static string getUsername()
        {
            return "";
        }
    }
}
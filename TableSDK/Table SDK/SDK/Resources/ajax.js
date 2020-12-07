(function(XHR) {
	"use strict";

	var open = XHR.prototype.open;
	var send = XHR.prototype.send;

	XHR.prototype.open = function(method, url, async, user, pass) {
		this._url = url;
		open.call(this, method, url, async, user, pass);
	};

	XHR.prototype.send = function(data) {
    	var self = this;
    	var url = this._url;
		var oldOnReadyStateChange;

		function onReadyStateChange() {
			if(self.readyState == 4 && self.status == 200) {
				webkit.messageHandlers.ajax.postMessage(self.responseText);
			}
			if(oldOnReadyStateChange) {
				oldOnReadyStateChange();
			}
		}

		if(url == 'https://app.table.co/api/user/signin') {
 			if(this.addEventListener) {
				this.addEventListener("readystatechange", onReadyStateChange, false);
			} else {
				oldOnReadyStateChange = this.onreadystatechange;
				this.onreadystatechange = onReadyStateChange;
			}
        }
        
		send.call(this, data);
	}
})(XMLHttpRequest);
(function(window) {
	"use strict";

	var oldFetch = window.fetch;
	window.fetch = function(url, options) {
		return oldFetch(url, options).then(function(response) {
			if(response.url == 'https://app.table.co/api/user/signin') {
				response.clone().text().then(function(text) {
					webkit.messageHandlers.ajax.postMessage(text);
				});
			}
			return response;
		});
	};
 
    window.mobile = {
        setUser: function(user) {
            webkit.messageHandlers.ajax.postMessage(user);
        },
        videocall: function(sessionId, token) {
            webkit.messageHandlers.videocall.postMessage({sessionId:sessionId, token:token})
        },
        jitsicall: function(server,tenant, roomID, jwt) {
            webkit.messageHandlers.jitsicall.postMessage({server:server, tenant:tenant, roomID:roomID, jwt:jwt})
        }
    };
 
})(window);

var deleteMessageTimer;
var hideMessageTimer;
var showMessageTimer;

function deleteMessage() {
	var existingMessage = document.querySelector(".messageDiv");
	if (existingMessage != null) {
		existingMessage.style.right = '-50%';
		deleteMessageTimer = setTimeout(
			function() {
				existingMessage.parentNode.removeChild(existingMessage);
			},
			210
		);
	}
}

function createMessage(currentMessage) {
	deleteMessage();

	var message = document.createElement('div');
	message.style.zIndex = '1000';
	message.style.cursor = 'pointer';

	var type = currentMessage.split(':splitter:')[0];

	if (type == 'danger' || type == 'success' || type == 'info') {
		var text = currentMessage.split(':splitter:')[1];
		if (type == 'danger') {
			message.className = 'messageDiv alert alert-danger';
			message.innerHTML = '<h4><strong>Error! </strong>' + text + '</h4>';
		}
		else if (type == 'success') {
			message.className = 'messageDiv alert alert-success';
			message.innerHTML = '<h4><strong>Success! </strong>' + text + '</h4>';
		}
		else if (type == 'info') {
			message.className = 'messageDiv alert alert-info';
			message.innerHTML = '<h4><strong>Tip! </strong>' + text + '</h4>';
		}

		document.body.appendChild(message);
		message.onclick = function() {
			message.style.right = '-50%';
		}

		showMessageTimer = setTimeout(
			function() {
				message.style.right = '1%';
			},
			100
		);
		hideMessageTimer = setTimeout(
			function() {
				message.style.right = '-50%';
			},
			7000
		);
	}
}
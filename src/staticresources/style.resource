/*calc(% - px)*/

			/*HTML*/
			html {
			  font-family: sans-serif !important;
			  -webkit-text-size-adjust: 100% !important;
			      -ms-text-size-adjust: 100% !important;
			  overflow-y: auto !important;
			}

			/*H's*/
			h1,
			h2,
			h3,
			h4,
			h5,
			h6,
			.h1,
			.h2,
			.h3,
			.h4,
			.h5,
			.h6 {
			  font-family: inherit !important;
			  font-weight: 500 !important;
			  line-height: 1.1 !important;
			  color: inherit !important;

			}
			h1 small,
			h2 small,
			h3 small,
			h4 small,
			h5 small,
			h6 small,
			.h1 small,
			.h2 small,
			.h3 small,
			.h4 small,
			.h5 small,
			.h6 small,
			h1 .small,
			h2 .small,
			h3 .small,
			h4 .small,
			h5 .small,
			h6 .small,
			.h1 .small,
			.h2 .small,
			.h3 .small,
			.h4 .small,
			.h5 .small,
			.h6 .small {
			  font-weight: normal !important;
			  line-height: 1 !important;
			  color: #777 !important;
			}
			h1,
			.h1,
			h2,
			.h2,
			h3,
			.h3 {
				-webkit-margin-before: 20px !important;
				-webkit-margin-after: 10px !important;
			}
			h1 small,
			.h1 small,
			h2 small,
			.h2 small,
			h3 small,
			.h3 small,
			h1 .small,
			.h1 .small,
			h2 .small,
			.h2 .small,
			h3 .small,
			.h3 .small {
			  font-size: 65% !important;
			}
			h4,
			.h4,
			h5,
			.h5,
			h6,
			.h6 {
			-webkit-margin-before: 10px !important;
			-webkit-margin-after: 10px !important;
			}
			h4 small,
			.h4 small,
			h5 small,
			.h5 small,
			h6 small,
			.h6 small,
			h4 .small,
			.h4 .small,
			h5 .small,
			.h5 .small,
			h6 .small,
			.h6 .small {
			  font-size: 75% !important;
			}
			h1,
			.h1 {
			  font-size: 36px !important;
			}
			h2,
			.h2 {
			  font-size: 30px !important;
			}
			h3,
			.h3 {
			  font-size: 24px !important;
			}
			h4,
			.h4 {
			  font-size: 18px !important;
			}
			h5,
			.h5 {
			  font-size: 14px !important;
			}
			h6,
			.h6 {
			  font-size: 12px !important;
			}

			/*Buttons*/

			.btn, input[type="button"], input[type="submit"], input[type="file"]{
			  display: inline-block !important;
			  padding: 6px 12px !important;
			  margin-bottom: 0 !important;
			  font-size: 14px !important;
			  font-weight: normal !important;
			  line-height: 1.42857143 !important;
			  text-align: center !important;
			  white-space: nowrap !important;
			  vertical-align: middle !important;
			  -ms-touch-action: manipulation !important;
			      touch-action: manipulation !important;
			  cursor: pointer !important;
			  -webkit-user-select: none !important;
			     -moz-user-select: none !important;
			      -ms-user-select: none !important;
			          user-select: none !important;
			  background-image: none !important;
			  border: 1px solid transparent !important;
			  border-radius: 4px !important;
			}
			.btn:focus,
			.btn:active:focus,
			.btn.active:focus,
			.btn.focus,
			.btn:active.focus,
			.btn.active.focus {
			  outline: thin dotted !important;
			  outline: 5px auto -webkit-focus-ring-color !important;
			  outline-offset: -2px !important;
			}
			.btn:hover,
			.btn:focus,
			.btn.focus {
			  color: #333 !important;
			  text-decoration: none !important;
			}
			.btn:active,
			.btn.active {
			  background-image: none !important;
			  outline: 0 !important;
			  -webkit-box-shadow: inset 0 3px 5px rgba(0, 0, 0, .125) !important;
			          box-shadow: inset 0 3px 5px rgba(0, 0, 0, .125) !important;
			}
			.btn.disabled,
			.btn[disabled],
			fieldset[disabled] .btn {
			  pointer-events: none !important;
			  cursor: not-allowed !important;
			  filter: alpha(opacity=65) !important;
			  -webkit-box-shadow: none !important;
			          box-shadow: none !important;
			  opacity: .65 !important;
			}
			.btn-default {
			  color: #333 !important;
			  background-color: #fff !important;
			  border-color: #ccc !important;
			}
			.btn-default:hover,
			.btn-default:focus,
			.btn-default.focus,
			.btn-default:active,
			.btn-default.active,
			.open > .dropdown-toggle.btn-default {
			  color: #333 !important;
			  background-color: #e6e6e6 !important;
			  border-color: #adadad !important;
			}
			.btn-default:active,
			.btn-default.active,
			.open > .dropdown-toggle.btn-default {
			  background-image: none !important;
			}
			.btn-default.disabled,
			.btn-default[disabled],
			fieldset[disabled] .btn-default,
			.btn-default.disabled:hover,
			.btn-default[disabled]:hover,
			fieldset[disabled] .btn-default:hover,
			.btn-default.disabled:focus,
			.btn-default[disabled]:focus,
			fieldset[disabled] .btn-default:focus,
			.btn-default.disabled.focus,
			.btn-default[disabled].focus,
			fieldset[disabled] .btn-default.focus,
			.btn-default.disabled:active,
			.btn-default[disabled]:active,
			fieldset[disabled] .btn-default:active,
			.btn-default.disabled.active,
			.btn-default[disabled].active,
			fieldset[disabled] .btn-default.active {
			  background-color: #fff !important;
			  border-color: #ccc !important;
			}
			.btn-default .badge {
			  color: #fff !important;
			  background-color: #333 !important;
			}
			.btn-primary {
			  color: #fff !important;
			  background-color: #337ab7 !important;
			  border-color: #2e6da4 !important;
			}
			.btn-primary:hover,
			.btn-primary:focus,
			.btn-primary.focus,
			.btn-primary:active,
			.btn-primary.active,
			.open > .dropdown-toggle.btn-primary {
			  color: #fff !important;
			  background-color: #286090 !important;
			  border-color: #204d74 !important;
			}
			.btn-primary:active,
			.btn-primary.active,
			.open > .dropdown-toggle.btn-primary {
			  background-image: none !important;
			}
			.btn-primary.disabled,
			.btn-primary[disabled],
			fieldset[disabled] .btn-primary,
			.btn-primary.disabled:hover,
			.btn-primary[disabled]:hover,
			fieldset[disabled] .btn-primary:hover,
			.btn-primary.disabled:focus,
			.btn-primary[disabled]:focus,
			fieldset[disabled] .btn-primary:focus,
			.btn-primary.disabled.focus,
			.btn-primary[disabled].focus,
			fieldset[disabled] .btn-primary.focus,
			.btn-primary.disabled:active,
			.btn-primary[disabled]:active,
			fieldset[disabled] .btn-primary:active,
			.btn-primary.disabled.active,
			.btn-primary[disabled].active,
			fieldset[disabled] .btn-primary.active {
			  background-color: #337ab7 !important;
			  border-color: #2e6da4 !important;
			}
			.btn-primary .badge {
			  color: #337ab7 !important;
			  background-color: #fff !important;
			}
			.btn-success {
			  color: #fff !important;
			  background-color: #5cb85c !important;
			  border-color: #4cae4c !important;
			}
			.btn-success:hover,
			.btn-success:focus,
			.btn-success.focus,
			.btn-success:active,
			.btn-success.active,
			.open > .dropdown-toggle.btn-success {
			  color: #fff !important;
			  background-color: #449d44 !important;
			  border-color: #398439 !important;
			}
			.btn-success:active,
			.btn-success.active,
			.open > .dropdown-toggle.btn-success {
			  background-image: none !important;
			}
			.btn-success.disabled,
			.btn-success[disabled],
			fieldset[disabled] .btn-success,
			.btn-success.disabled:hover,
			.btn-success[disabled]:hover,
			fieldset[disabled] .btn-success:hover,
			.btn-success.disabled:focus,
			.btn-success[disabled]:focus,
			fieldset[disabled] .btn-success:focus,
			.btn-success.disabled.focus,
			.btn-success[disabled].focus,
			fieldset[disabled] .btn-success.focus,
			.btn-success.disabled:active,
			.btn-success[disabled]:active,
			fieldset[disabled] .btn-success:active,
			.btn-success.disabled.active,
			.btn-success[disabled].active,
			fieldset[disabled] .btn-success.active {
			  background-color: #5cb85c !important;
			  border-color: #4cae4c !important;
			}
			.btn-success .badge {
			  color: #5cb85c !important;
			  background-color: #fff !important;
			}
			.btn-info {
			  color: #fff !important;
			  background-color: #5bc0de !important;
			  border-color: #46b8da !important;
			}
			.btn-info:hover,
			.btn-info:focus,
			.btn-info.focus,
			.btn-info:active,
			.btn-info.active,
			.open > .dropdown-toggle.btn-info {
			  color: #fff !important;
			  background-color: #31b0d5 !important;
			  border-color: #269abc !important;
			}
			.btn-info:active,
			.btn-info.active,
			.open > .dropdown-toggle.btn-info {
			  background-image: none !important;
			}
			.btn-info.disabled,
			.btn-info[disabled],
			fieldset[disabled] .btn-info,
			.btn-info.disabled:hover,
			.btn-info[disabled]:hover,
			fieldset[disabled] .btn-info:hover,
			.btn-info.disabled:focus,
			.btn-info[disabled]:focus,
			fieldset[disabled] .btn-info:focus,
			.btn-info.disabled.focus,
			.btn-info[disabled].focus,
			fieldset[disabled] .btn-info.focus,
			.btn-info.disabled:active,
			.btn-info[disabled]:active,
			fieldset[disabled] .btn-info:active,
			.btn-info.disabled.active,
			.btn-info[disabled].active,
			fieldset[disabled] .btn-info.active {
			  background-color: #5bc0de !important;
			  border-color: #46b8da !important;
			}
			.btn-info .badge {
			  color: #5bc0de !important;
			  background-color: #fff !important;
			}
			.btn-warning {
			  color: #fff !important;
			  background-color: #f0ad4e !important;
			  border-color: #eea236 !important;
			}
			.btn-warning:hover,
			.btn-warning:focus,
			.btn-warning.focus,
			.btn-warning:active,
			.btn-warning.active,
			.open > .dropdown-toggle.btn-warning {
			  color: #fff !important;
			  background-color: #ec971f !important;
			  border-color: #d58512 !important;
			}
			.btn-warning:active,
			.btn-warning.active,
			.open > .dropdown-toggle.btn-warning {
			  background-image: none !important;
			}
			.btn-warning.disabled,
			.btn-warning[disabled],
			fieldset[disabled] .btn-warning,
			.btn-warning.disabled:hover,
			.btn-warning[disabled]:hover,
			fieldset[disabled] .btn-warning:hover,
			.btn-warning.disabled:focus,
			.btn-warning[disabled]:focus,
			fieldset[disabled] .btn-warning:focus,
			.btn-warning.disabled.focus,
			.btn-warning[disabled].focus,
			fieldset[disabled] .btn-warning.focus,
			.btn-warning.disabled:active,
			.btn-warning[disabled]:active,
			fieldset[disabled] .btn-warning:active,
			.btn-warning.disabled.active,
			.btn-warning[disabled].active,
			fieldset[disabled] .btn-warning.active {
			  background-color: #f0ad4e !important;
			  border-color: #eea236 !important;
			}
			.btn-warning .badge {
			  color: #f0ad4e !important;
			  background-color: #fff !important;
			}
			.btn-danger {
			  color: #fff !important;
			  background-color: #d9534f !important;
			  border-color: #d43f3a !important;
			}
			.btn-danger:hover,
			.btn-danger:focus,
			.btn-danger.focus,
			.btn-danger:active,
			.btn-danger.active,
			.open > .dropdown-toggle.btn-danger {
			  color: #fff !important;
			  background-color: #c9302c !important;
			  border-color: #ac2925 !important;
			}
			.btn-danger:active,
			.btn-danger.active,
			.open > .dropdown-toggle.btn-danger {
			  background-image: none !important;
			}
			.btn-danger.disabled,
			.btn-danger[disabled],
			fieldset[disabled] .btn-danger,
			.btn-danger.disabled:hover,
			.btn-danger[disabled]:hover,
			fieldset[disabled] .btn-danger:hover,
			.btn-danger.disabled:focus,
			.btn-danger[disabled]:focus,
			fieldset[disabled] .btn-danger:focus,
			.btn-danger.disabled.focus,
			.btn-danger[disabled].focus,
			fieldset[disabled] .btn-danger.focus,
			.btn-danger.disabled:active,
			.btn-danger[disabled]:active,
			fieldset[disabled] .btn-danger:active,
			.btn-danger.disabled.active,
			.btn-danger[disabled].active,
			fieldset[disabled] .btn-danger.active {
			  background-color: #d9534f !important;
			  border-color: #d43f3a !important;
			}
			.btn-danger .badge {
			  color: #d9534f !important;
			  background-color: #fff !important;
			}
			.btn-link {
			  font-weight: normal !important;
			  color: #337ab7 !important;
			  border-radius: 0 !important;
			}
			.btn-link,
			.btn-link:active,
			.btn-link.active,
			.btn-link[disabled],
			fieldset[disabled] .btn-link {
			  background-color: transparent !important;
			  -webkit-box-shadow: none !important;
			          box-shadow: none !important;
			}
			.btn-link,
			.btn-link:hover,
			.btn-link:focus,
			.btn-link:active {
			  border-color: transparent !important;
			}
			.btn-link:hover,
			.btn-link:focus {
			  color: #23527c !important;
			  text-decoration: underline !important;
			  background-color: transparent !important;
			}
			.btn-link[disabled]:hover,
			fieldset[disabled] .btn-link:hover,
			.btn-link[disabled]:focus,
			fieldset[disabled] .btn-link:focus {
			  color: #777 !important;
			  text-decoration: none !important;
			}
			.btn-lg,
			.btn-group-lg > .btn {
			  padding: 10px 16px !important;
			  font-size: 18px !important;
			  line-height: 1.3333333 !important;
			  border-radius: 6px !important;
			}
			.btn-sm,
			.btn-group-sm > .btn {
			  padding: 5px 10px !important;
			  font-size: 12px !important;
			  line-height: 1.5 !important;
			  border-radius: 3px !important;
			}
			.btn-xs,
			.btn-group-xs > .btn {
			  padding: 1px 5px !important;
			  font-size: 12px !important;
			  line-height: 1.5 !important;
			  border-radius: 3px !important;
			}
			.btn-block {
			  display: block !important;
			  width: 100% !important;
			}
			.btn-block + .btn-block {
			  margin-top: 5px !important;
			}
			.btn-default,

			.btn-primary,
			.btn-success,
			.btn-info,
			.btn-warning,
			.btn-danger {
			  text-shadow: 0 -1px 0 rgba(0, 0, 0, .2) !important;
			  -webkit-box-shadow: inset 0 1px 0 rgba(255, 255, 255, .15), 0 1px 1px rgba(0, 0, 0, .075) !important;
			          box-shadow: inset 0 1px 0 rgba(255, 255, 255, .15), 0 1px 1px rgba(0, 0, 0, .075) !important;
			}
			.btn-default:active,
			.btn-primary:active,
			.btn-success:active,
			.btn-info:active,
			.btn-warning:active,
			.btn-danger:active,
			.btn-default.active,
			.btn-primary.active,
			.btn-success.active,
			.btn-info.active,
			.btn-warning.active,
			.btn-danger.active {
			  -webkit-box-shadow: inset 0 3px 5px rgba(0, 0, 0, .125) !important;
			          box-shadow: inset 0 3px 5px rgba(0, 0, 0, .125) !important;
			}
			.btn-default .badge,
			.btn-primary .badge,
			.btn-success .badge,
			.btn-info .badge,
			.btn-warning .badge,
			.btn-danger .badge {
			  text-shadow: none !important;
			}
			.btn:active,
			.btn.active {
			  background-image: none !important;
			}
			.btn-default {
			  text-shadow: 0 1px 0 #fff !important;
			  background-image: -webkit-linear-gradient(top, #fff 0%, #e0e0e0 100%) !important;
			  background-image:      -o-linear-gradient(top, #fff 0%, #e0e0e0 100%) !important;
			  background-image: -webkit-gradient(linear, left top, left bottom, from(#fff), to(#e0e0e0)) !important;
			  background-image:         linear-gradient(to bottom, #fff 0%, #e0e0e0 100%) !important;
			  filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ffffffff', endColorstr='#ffe0e0e0', GradientType=0) !important;
			  filter: progid:DXImageTransform.Microsoft.gradient(enabled = false) !important;
			  background-repeat: repeat-x !important;
			  border-color: #dbdbdb !important;
			  border-color: #ccc !important;
			}
			.btn-default:hover,
			.btn-default:focus {
			  background-color: #e0e0e0 !important;
			  background-position: 0 -15px !important;
			}
			.btn-default:active,
			.btn-default.active {
			  background-color: #e0e0e0 !important;
			  border-color: #dbdbdb !important;
			}
			.btn-default.disabled,
			.btn-default:disabled,
			.btn-default[disabled] {
			  background-color: #e0e0e0 !important;
			  background-image: none !important;
			}
			.btn-primary {
			  background-image: -webkit-linear-gradient(top, #337ab7 0%, #265a88 100%) !important;
			  background-image:      -o-linear-gradient(top, #337ab7 0%, #265a88 100%) !important;
			  background-image: -webkit-gradient(linear, left top, left bottom, from(#337ab7), to(#265a88)) !important;
			  background-image:         linear-gradient(to bottom, #337ab7 0%, #265a88 100%) !important;
			  filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ff337ab7', endColorstr='#ff265a88', GradientType=0) !important;
			  filter: progid:DXImageTransform.Microsoft.gradient(enabled = false) !important;
			  background-repeat: repeat-x !important;
			  border-color: #245580 !important;
			}
			.btn-primary:hover,
			.btn-primary:focus {
			  background-color: #265a88 !important;
			  background-position: 0 -15px !important;
			}
			.btn-primary:active,
			.btn-primary.active {
			  background-color: #265a88 !important;
			  border-color: #245580 !important;
			}
			.btn-primary.disabled,
			.btn-primary:disabled,
			.btn-primary[disabled] {
			  background-color: #265a88 !important;
			  background-image: none !important;
			}
			.btn-success {
			  background-image: -webkit-linear-gradient(top, #5cb85c 0%, #419641 100%) !important;
			  background-image:      -o-linear-gradient(top, #5cb85c 0%, #419641 100%) !important;
			  background-image: -webkit-gradient(linear, left top, left bottom, from(#5cb85c), to(#419641)) !important;
			  background-image:         linear-gradient(to bottom, #5cb85c 0%, #419641 100%) !important;
			  filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ff5cb85c', endColorstr='#ff419641', GradientType=0) !important;
			  filter: progid:DXImageTransform.Microsoft.gradient(enabled = false) !important;
			  background-repeat: repeat-x !important;
			  border-color: #3e8f3e !important;
			}
			.btn-success:hover,
			.btn-success:focus {
			  background-color: #419641 !important;
			  background-position: 0 -15px !important;
			}
			.btn-success:active,
			.btn-success.active {
			  background-color: #419641 !important;
			  border-color: #3e8f3e !important;
			}
			.btn-success.disabled,
			.btn-success:disabled,
			.btn-success[disabled] {
			  background-color: #419641 !important;
			  background-image: none !important;
			}
			.btn-info {
			  background-image: -webkit-linear-gradient(top, #5bc0de 0%, #2aabd2 100%) !important;
			  background-image:      -o-linear-gradient(top, #5bc0de 0%, #2aabd2 100%) !important;
			  background-image: -webkit-gradient(linear, left top, left bottom, from(#5bc0de), to(#2aabd2)) !important;
			  background-image:         linear-gradient(to bottom, #5bc0de 0%, #2aabd2 100%) !important;
			  filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ff5bc0de', endColorstr='#ff2aabd2', GradientType=0) !important;
			  filter: progid:DXImageTransform.Microsoft.gradient(enabled = false) !important;
			  background-repeat: repeat-x !important;
			  border-color: #28a4c9 !important;
			}
			.btn-info:hover,
			.btn-info:focus {
			  background-color: #2aabd2 !important;
			  background-position: 0 -15px !important;
			}
			.btn-info:active,
			.btn-info.active {
			  background-color: #2aabd2 !important;
			  border-color: #28a4c9 !important;
			}
			.btn-info.disabled,
			.btn-info:disabled,
			.btn-info[disabled] {
			  background-color: #2aabd2 !important;
			  background-image: none !important;
			}
			.btn-warning {
			  background-image: -webkit-linear-gradient(top, #f0ad4e 0%, #eb9316 100%) !important;
			  background-image:      -o-linear-gradient(top, #f0ad4e 0%, #eb9316 100%) !important;
			  background-image: -webkit-gradient(linear, left top, left bottom, from(#f0ad4e), to(#eb9316)) !important;
			  background-image:         linear-gradient(to bottom, #f0ad4e 0%, #eb9316 100%) !important;
			  filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#fff0ad4e', endColorstr='#ffeb9316', GradientType=0) !important;
			  filter: progid:DXImageTransform.Microsoft.gradient(enabled = false) !important;
			  background-repeat: repeat-x !important;
			  border-color: #e38d13 !important;
			}
			.btn-warning:hover,
			.btn-warning:focus {
			  background-color: #eb9316 !important;
			  background-position: 0 -15px !important;
			}
			.btn-warning:active,
			.btn-warning.active {
			  background-color: #eb9316 !important;
			  border-color: #e38d13 !important;
			}
			.btn-warning.disabled,
			.btn-warning:disabled,
			.btn-warning[disabled] {
			  background-color: #eb9316 !important;
			  background-image: none !important;
			}
			.btn-danger {
			  background-image: -webkit-linear-gradient(top, #d9534f 0%, #c12e2a 100%) !important;
			  background-image:      -o-linear-gradient(top, #d9534f 0%, #c12e2a 100%) !important;
			  background-image: -webkit-gradient(linear, left top, left bottom, from(#d9534f), to(#c12e2a)) !important;
			  background-image:         linear-gradient(to bottom, #d9534f 0%, #c12e2a 100%) !important;
			  filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ffd9534f', endColorstr='#ffc12e2a', GradientType=0) !important;
			  filter: progid:DXImageTransform.Microsoft.gradient(enabled = false) !important;
			  background-repeat: repeat-x !important;
			  border-color: #b92c28 !important;
			}
			.btn-danger:hover,
			.btn-danger:focus {
			  background-color: #c12e2a !important;
			  background-position: 0 -15px !important;
			}
			.btn-danger:active,
			.btn-danger.active {
			  background-color: #c12e2a !important;
			  border-color: #b92c28 !important;
			}
			.btn-danger.disabled,
			.btn-danger:disabled,
			.btn-danger[disabled] {
			  background-color: #c12e2a !important;
			  background-image: none !important;
			}
			.btn {
			  position: relative !important;
			  top: -1px !important;
			}
			input[type="button"],
			input[type="reset"],
			input[type="submit"] {
			  -webkit-appearance: button !important;
			  cursor: pointer !important;
			}

			/*Inputs*/

			input[type="text"], input[type="password"] {
			  margin: 2px auto !important;
			  display: block !important;
			  width: 97.6% !important;
			  /*height: 34px !important;*/
			  padding: 6px 12px !important;
			  font-size: 14px !important;
			  line-height: 1.42857143 !important;
			  color: #555 !important;
			  background-color: #fff !important;
			  background-image: none !important;
			  border: 1px solid #ccc !important;
			  border-radius: 4px !important;
			  -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075) !important;
			          box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075) !important;
			  -webkit-transition: border-color ease-in-out .15s, -webkit-box-shadow ease-in-out .15s !important;
			       -o-transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s !important;
			          transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s !important;

			  	-webkit-box-sizing: border-box !important; /* Safari/Chrome, other WebKit */
			    -moz-box-sizing: border-box !important;    /* Firefox, other Gecko */
			    box-sizing: border-box !important;
			}
			input[type="text"]:focus, input[type="password"]:focus {
				  border-color: #66afe9 !important;
				  outline: 0 !important;
				  -webkit-box-shadow: inset 0 1px 1px rgba(0,0,0,.075), 0 0 8px rgba(102, 175, 233, .6) !important;
				          box-shadow: inset 0 1px 1px rgba(0,0,0,.075), 0 0 8px rgba(102, 175, 233, .6) !important;
			}
			input[type="text"]::-moz-placeholder, input[type="password"]::-moz-placeholder {
			  color: #999 !important;
			  opacity: 1 !important;
			}
			input[type="text"]:-ms-input-placeholder, input[type="password"]:-ms-input-placeholder {
			  color: #999 !important;
			}
			input[type="text"]::-webkit-input-placeholder, input[type="password"]::-webkit-input-placeholder {
			  color: #999 !important;
			}
			input {
			  margin: 2px !important;
			  font: inherit !important;
			  color: inherit !important;
			}
			input::-moz-focus-inner {
			  padding: 0 !important;
			  border: 0 !important;
			}
			input {
			  line-height: normal !important;
			}
			textarea {
			  display: block !important;
			  width: 97.6% !important;
			  height: 100px;
			  padding: 6px 12px !important;
			  color: #555 !important;
			  background-color: #fff !important;
			  background-image: none !important;
			  border: 1px solid #ccc !important;
			  border-radius: 4px !important;
			  -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075) !important;
			          box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075) !important;
			  -webkit-transition: border-color ease-in-out .15s, -webkit-box-shadow ease-in-out .15s !important;
			       -o-transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s !important;
			          transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s !important;
			  margin: 2px auto !important;
			  font: inherit !important;
			  overflow: auto !important;
			  font-family: inherit !important;
			  font-size: inherit !important;
			  line-height: inherit !important;
			  -webkit-box-sizing: border-box !important; /* Safari/Chrome, other WebKit */
			   -moz-box-sizing: border-box !important;    /* Firefox, other Gecko */
			   box-sizing: border-box !important;
			}
			textarea:focus {
			  border-color: #66afe9 !important;
			  outline: 0 !important;
			  -webkit-box-shadow: inset 0 1px 1px rgba(0,0,0,.075), 0 0 8px rgba(102, 175, 233, .6) !important;
			          box-shadow: inset 0 1px 1px rgba(0,0,0,.075), 0 0 8px rgba(102, 175, 233, .6) !important;
			}
			textarea::-moz-placeholder {
			  color: #999 !important;
			  opacity: 1 !important;
			}
			textarea:-ms-input-placeholder {
			  color: #999 !important;
			}
			textarea::-webkit-input-placeholder {
			  color: #999 !important;
			}

			input[type="checkbox"], input[type="radio"] {
			  margin-left: 12px !important;
			}

			/*Labels*/

			 label {
			  font-size: 18px !important;
			  font-weight: normal !important;
			  line-height: 1.8 !important;
			  color: #777 !important;
			  display: inline-block !important;
			  max-width: 100% !important;
			  margin-bottom: 5px !important;
			  display: inline !important;
			  padding: .2em .6em .3em .4em !important;
			  text-align: center !important;
			  white-space: nowrap !important;
			  vertical-align: baseline !important;
			  border-radius: .25em !important;
			  margin: .2em .2em .2em .2em !important;
			}
			th > label {
				padding: 0px !important;
			}
			.label {
			  display: inline !important;
			  padding: .2em .6em .3em .4em !important;
			  font-size: 75% !important;
			  font-weight: bold !important;
			  line-height: 1.8 !important;
			  color: #fff !important;
			  text-align: center !important;
			  white-space: nowrap !important;
			  vertical-align: baseline !important;
			  border-radius: .25em !important;
			  margin: .2em .2em .2em .2em !important;
			}
			a.label:hover,
			a.label:focus {
			  color: #fff !important;
			  text-decoration: none !important;
			  cursor: pointer !important;
			}
			.label:empty {
			  display: none !important;
			}
			.label {
			  position: relative !important;
			  top: -1px !important;
			}
			.label-default {
			  background-color: #777 !important;
			}
			.label-default[href]:hover,
			.label-default[href]:focus {
			  background-color: #5e5e5e !important;
			}
			.label-primary {
			  background-color: #337ab7 !important;
			}
			.label-primary[href]:hover,
			.label-primary[href]:focus {
			  background-color: #286090 !important;
			}
			.label-success {
			  background-color: #5cb85c !important;
			}
			.label-success[href]:hover,
			.label-success[href]:focus {
			  background-color: #449d44 !important;
			}
			.label-info {
			  background-color: #5bc0de !important;
			}
			.label-info[href]:hover,
			.label-info[href]:focus {
			  background-color: #31b0d5 !important;
			}
			.label-warning {
			  background-color: #f0ad4e !important;
			}
			.label-warning[href]:hover,
			.label-warning[href]:focus {
			  background-color: #ec971f !important;
			}
			.label-danger {
			  background-color: #d9534f !important;
			}
			.label-danger[href]:hover,
			.label-danger[href]:focus {
			  background-color: #c9302c !important;
			}

			/*Tables*/

			th {
				vertical-align: middle !important;
			}
			table .multiSelectPicklistTable {
				width: 97.4% !important;
			}
			table .list > tbody > tr:nth-of-type(odd) {
			  background-color: #f9f9f9 !important;
			}
			td .multiSelectPicklistCell {
				width: 40px !important;
			}

			/*Selects*/

			select {
			  display: block;
			  width: 97.6% !important;
			  /*height: 34px !important;*/
			  padding: 6px 12px !important;
			  margin: 2px auto !important;
			  font-size: 14px !important;
			  line-height: 1.42857143 !important;
			  color: #555 !important;
			  background-color: #fff !important;
			  background-image: none !important;
			  border: 1px solid #ccc !important;
			  border-radius: 4px !important;
			  -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075) !important;
			          box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075) !important;
			  -webkit-transition: border-color ease-in-out .15s, -webkit-box-shadow ease-in-out .15s !important;
			       -o-transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s !important;
			          transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s !important;
			}
			select:focus {
			  border-color: #66afe9 !important;
			  outline: 0 !important;
			  -webkit-box-shadow: inset 0 1px 1px rgba(0,0,0,.075), 0 0 8px rgba(102, 175, 233, .6) !important;
			          box-shadow: inset 0 1px 1px rgba(0,0,0,.075), 0 0 8px rgba(102, 175, 233, .6) !important;
			}
			select::-moz-placeholder {
			  color: #999 !important;
			  opacity: 1 !important;
			}
			select:-ms-input-placeholder {
			  color: #999 !important;
			}
			select::-webkit-input-placeholder {
			  color: #999 !important;
			}

			/*Navbar*/

			.navbar {
			  position: relative !important;
			  min-height: 50px !important;
			  margin-bottom: 20px !important;
			  border: 1px solid transparent !important;
			}
			@media (min-width: 768px) {
			  .navbar {
			    border-radius: 4px !important;
			  }
			}
			@media (min-width: 768px) {
			  .navbar-header {
			    float: left !important;
			  }
			}
			.navbar-collapse {
			  padding-right: 15px !important;
			  padding-left: 15px !important;
			  overflow-x: visible !important;
			  -webkit-overflow-scrolling: touch !important;
			  border-top: 1px solid transparent !important;
			  -webkit-box-shadow: inset 0 1px 0 rgba(255, 255, 255, .1) !important;
			          box-shadow: inset 0 1px 0 rgba(255, 255, 255, .1) !important;
			}
			.navbar-collapse.in {
			  overflow-y: auto !important;
			}
			@media (min-width: 768px) {
			  .navbar-collapse {
			    width: auto !important;
			    border-top: 0 !important;
			    -webkit-box-shadow: none !important;
			            box-shadow: none !important;
			  }
			  .navbar-collapse.collapse {
			    display: block !important;
			    height: auto !important;
			    padding-bottom: 0 !important;
			    overflow: visible !important;
			    visibility: visible !important;
			  }
			  .navbar-collapse.in {
			    overflow-y: visible !important;
			  }
			  .navbar-fixed-top .navbar-collapse,
			  .navbar-static-top .navbar-collapse,
			  .navbar-fixed-bottom .navbar-collapse {
			    padding-right: 0 !important;
			    padding-left: 0 !important;
			  }
			}
			.navbar-fixed-top .navbar-collapse,
			.navbar-fixed-bottom .navbar-collapse {
			  max-height: 340px !important;
			}
			@media (max-device-width: 480px) and (orientation: landscape) {
			  .navbar-fixed-top .navbar-collapse,
			  .navbar-fixed-bottom .navbar-collapse {
			    max-height: 200px !important;
			  }
			}
			.container > .navbar-header,
			.container-fluid > .navbar-header,
			.container > .navbar-collapse,
			.container-fluid > .navbar-collapse {
			  margin-right: -15px !important;
			  margin-left: -15px !important;
			}
			@media (min-width: 768px) {
			  .container > .navbar-header,
			  .container-fluid > .navbar-header,
			  .container > .navbar-collapse,
			  .container-fluid > .navbar-collapse {
			    margin-right: 0 !important;
			    margin-left: 0 !important;
			  }
			}
			.navbar-static-top {
			  z-index: 1000 !important;
			  border-width: 0 0 1px !important;
			}
			@media (min-width: 768px) {
			  .navbar-static-top {
			    border-radius: 0 !important;
			  }
			}
			.navbar-fixed-top,
			.navbar-fixed-bottom {
			  position: fixed !important;
			  right: 0 !important;
			  left: 0 !important;
			  z-index: 1030 !important;
			}
			@media (min-width: 768px) {
			  .navbar-fixed-top,
			  .navbar-fixed-bottom {
			    border-radius: 0 !important;
			  }
			}
			.navbar-fixed-top {
			  top: 0 !important;
			  border-width: 0 0 1px !important;
			}
			.navbar-fixed-bottom {
			  bottom: 0 !important;
			  margin-bottom: 0 !important;
			  border-width: 1px 0 0 !important;
			}
			.navbar-brand {
			  float: left !important;
			  padding: 15px 15px !important;
			  font-size: 18px !important;
			  line-height: 20px !important;
			}
			.navbar-brand:hover,
			.navbar-brand:focus {
			  text-decoration: none !important;
			}
			.navbar-brand > img {
			  display: block !important;
			}
			.navbar-toggle {
			  position: relative !important;
			  float: right !important;
			  padding: 9px 10px !important;
			  margin-top: 8px !important;
			  margin-right: 15px !important;
			  margin-bottom: 8px !important;
			  background-color: transparent !important;
			  background-image: none !important;
			  border: 1px solid transparent !important;
			  border-radius: 4px !important;
			}
			.navbar-toggle:focus {
			  outline: 0 !important;
			}
			.navbar-toggle .icon-bar {
			  display: block !important;
			  width: 22px !important;
			  height: 2px !important;
			  border-radius: 1px !important;
			}
			.navbar-toggle .icon-bar + .icon-bar {
			  margin-top: 4px !important;
			}
			@media (min-width: 768px) {
			  .navbar-toggle {
			    display: none !important;
			  }
			}
			.navbar-nav {
			  margin: 7.5px -15px !important;
			}
			.navbar-nav > li > a {
			  padding-top: 10px !important;
			  padding-bottom: 10px !important;
			  line-height: 20px !important;
			}
			@media (max-width: 767px) {
			  .navbar-nav .open .dropdown-menu {
			    position: static !important;
			    float: none !important;
			    width: auto !important;
			    margin-top: 0 !important;
			    background-color: transparent !important;
			    border: 0 !important;
			    -webkit-box-shadow: none !important;
			            box-shadow: none !important;
			  }
			  .navbar-nav .open .dropdown-menu > li > a,
			  .navbar-nav .open .dropdown-menu .dropdown-header {
			    padding: 5px 15px 5px 25px !important;
			  }
			  .navbar-nav .open .dropdown-menu > li > a {
			    line-height: 20px !important;
			  }
			  .navbar-nav .open .dropdown-menu > li > a:hover,
			  .navbar-nav .open .dropdown-menu > li > a:focus {
			    background-image: none !important;
			  }
			}
			@media (min-width: 768px) {
			  .navbar-nav {
			    float: none !important;
			    margin: 0 !important;
			  }
			  .navbar-nav > li {
			    float: left !important;
			  }
			  .navbar-nav > li > a {
			    padding-top: 15px !important;
			    padding-bottom: 15px !important;
			  }
			}
			.navbar-form {
			  padding: 10px 15px !important;
			  margin-top: 8px !important;
			  margin-right: -15px !important;
			  margin-bottom: 8px !important;
			  margin-left: -15px !important;
			  border-top: 1px solid transparent !important;
			  border-bottom: 1px solid transparent !important;
			  -webkit-box-shadow: inset 0 1px 0 rgba(255, 255, 255, .1), 0 1px 0 rgba(255, 255, 255, .1) !important;
			          box-shadow: inset 0 1px 0 rgba(255, 255, 255, .1), 0 1px 0 rgba(255, 255, 255, .1) !important;
			}
			@media (min-width: 768px) {
			  .navbar-form .form-group {
			    display: inline-block !important;
			    margin-bottom: 0 !important;
			    vertical-align: middle !important;
			  }
			  .navbar-form .form-control {
			    display: inline-block !important;
			    width: auto !important;
			    vertical-align: middle !important;
			  }
			  .navbar-form .form-control-static {
			    display: inline-block !important;
			  }
			  .navbar-form .input-group {
			    display: inline-table !important;
			    vertical-align: middle !important;
			  }
			  .navbar-form .input-group .input-group-addon,
			  .navbar-form .input-group .input-group-btn,
			  .navbar-form .input-group .form-control {
			    width: auto !important;
			  }
			  .navbar-form .input-group > .form-control {
			    width: 100% !important;
			  }
			  .navbar-form .control-label {
			    margin-bottom: 0 !important;
			    vertical-align: middle !important;
			  }
			  .navbar-form .radio,
			  .navbar-form .checkbox {
			    display: inline-block !important;
			    margin-top: 0 !important;
			    margin-bottom: 0 !important;
			    vertical-align: middle !important;
			  }
			  .navbar-form .radio label,
			  .navbar-form .checkbox label {
			    padding-left: 0 !important;
			  }
			  .navbar-form .radio input[type="radio"],
			  .navbar-form .checkbox input[type="checkbox"] {
			    position: relative !important;
			    margin-left: 0 !important;
			  }
			  .navbar-form .has-feedback .form-control-feedback {
			    top: 0 !important;
			  }
			}
			@media (max-width: 767px) {
			  .navbar-form .form-group {
			    margin-bottom: 5px !important;
			  }
			  .navbar-form .form-group:last-child {
			    margin-bottom: 0 !important;
			  }
			}
			@media (min-width: 768px) {
			  .navbar-form {
			    width: auto !important;
			    padding-top: 0 !important;
			    padding-bottom: 0 !important;
			    margin-right: 0 !important;
			    margin-left: 0 !important;
			    border: 0 !important;
			    -webkit-box-shadow: none !important;
			            box-shadow: none !important;
			  }
			}
			.navbar-nav > li > .dropdown-menu {
			  margin-top: 0 !important;
			  border-top-left-radius: 0 !important;
			  border-top-right-radius: 0 !important;
			}
			.navbar-fixed-bottom .navbar-nav > li > .dropdown-menu {
			  margin-bottom: 0 !important;
			  border-top-left-radius: 4px !important;
			  border-top-right-radius: 4px !important;
			  border-bottom-right-radius: 0 !important;
			  border-bottom-left-radius: 0 !important;
			}
			.navbar-btn {
			  margin-top: 8px !important;
			  margin-bottom: 8px !important;
			}
			.navbar-btn.btn-sm {
			  margin-top: 10px !important;
			  margin-bottom: 10px !important;
			}
			.navbar-btn.btn-xs {
			  margin-top: 14px !important;
			  margin-bottom: 14px !important;
			}
			.navbar-text {
			  margin-top: 15px !important;
			  margin-bottom: 15px !important;
			}
			@media (min-width: 768px) {
			  .navbar-text {
			    float: left !important;
			    margin-right: 15px !important;
			    margin-left: 15px !important;
			  }
			}
			@media (min-width: 768px) {
			  .navbar-left {
			    float: left !important;
			  }
			  .navbar-right {
			    float: right !important;
			    margin-right: -15px !important;
			  }
			  .navbar-right ~ .navbar-right {
			    margin-right: 0 !important;
			  }
			}
			.navbar-default {
			  background-color: #f8f8f8 !important;
			  border-color: #e7e7e7 !important;
			}
			.navbar-default .navbar-brand {
			  color: #777 !important;
			}
			.navbar-default .navbar-brand:hover,
			.navbar-default .navbar-brand:focus {
			  color: #5e5e5e !important;
			  background-color: transparent !important;
			}
			.navbar-default .navbar-text {
			  color: #777 !important;
			}
			.navbar-default .navbar-nav > li > a {
			  color: #777 !important;
			}
			.navbar-default .navbar-nav > li > a:hover,
			.navbar-default .navbar-nav > li > a:focus {
			  color: #333 !important;
			  background-color: transparent !important;
			}
			.navbar-default .navbar-nav > .active > a,
			.navbar-default .navbar-nav > .active > a:hover,
			.navbar-default .navbar-nav > .active > a:focus {
			  color: #555 !important;
			  background-color: #e7e7e7 !important;
			}
			.navbar-default .navbar-nav > .disabled > a,
			.navbar-default .navbar-nav > .disabled > a:hover,
			.navbar-default .navbar-nav > .disabled > a:focus {
			  color: #ccc !important;
			  background-color: transparent !important;
			}
			.navbar-default .navbar-toggle {
			  border-color: #ddd !important;
			}
			.navbar-default .navbar-toggle:hover,
			.navbar-default .navbar-toggle:focus {
			  background-color: #ddd !important;
			}
			.navbar-default .navbar-toggle .icon-bar {
			  background-color: #888 !important;
			}
			.navbar-default .navbar-collapse,
			.navbar-default .navbar-form {
			  border-color: #e7e7e7 !important;
			}
			.navbar-default .navbar-nav > .open > a,
			.navbar-default .navbar-nav > .open > a:hover,
			.navbar-default .navbar-nav > .open > a:focus {
			  color: #555 !important;
			  background-color: #e7e7e7 !important;
			}
			@media (max-width: 767px) {
			  .navbar-default .navbar-nav .open .dropdown-menu > li > a {
			    color: #777 !important;
			  }
			  .navbar-default .navbar-nav .open .dropdown-menu > li > a:hover,
			  .navbar-default .navbar-nav .open .dropdown-menu > li > a:focus {
			    color: #333 !important;
			    background-color: transparent !important;
			  }
			  .navbar-default .navbar-nav .open .dropdown-menu > .active > a,
			  .navbar-default .navbar-nav .open .dropdown-menu > .active > a:hover,
			  .navbar-default .navbar-nav .open .dropdown-menu > .active > a:focus {
			    color: #555 !important;
			    background-color: #e7e7e7 !important;
			  }
			  .navbar-default .navbar-nav .open .dropdown-menu > .disabled > a,
			  .navbar-default .navbar-nav .open .dropdown-menu > .disabled > a:hover,
			  .navbar-default .navbar-nav .open .dropdown-menu > .disabled > a:focus {
			    color: #ccc !important;
			    background-color: transparent !important;
			  }
			}
			.navbar-default .navbar-link {
			  color: #777 !important;
			}
			.navbar-default .navbar-link:hover {
			  color: #333 !important;
			}
			.navbar-default .btn-link {
			  color: #777 !important;
			}
			.navbar-default .btn-link:hover,
			.navbar-default .btn-link:focus {
			  color: #333 !important;
			}
			.navbar-default .btn-link[disabled]:hover,
			fieldset[disabled] .navbar-default .btn-link:hover,
			.navbar-default .btn-link[disabled]:focus,
			fieldset[disabled] .navbar-default .btn-link:focus {
			  color: #ccc !important;
			}
			.navbar-inverse {
			  background-color: #222 !important;
			  border-color: #080808 !important;
			}
			.navbar-inverse .navbar-brand {
			  color: #9d9d9d !important;
			}
			.navbar-inverse .navbar-brand:hover,
			.navbar-inverse .navbar-brand:focus {
			  color: #fff !important;
			  background-color: transparent !important;
			}
			.navbar-inverse .navbar-text {
			  color: #9d9d9d !important;
			}
			.navbar-inverse .navbar-nav > li > a {
			  color: #9d9d9d !important;
			}
			.navbar-inverse .navbar-nav > li > a:hover,
			.navbar-inverse .navbar-nav > li > a:focus {
			  color: #fff !important;
			  background-color: transparent !important;
			}
			.navbar-inverse .navbar-nav > .active > a,
			.navbar-inverse .navbar-nav > .active > a:hover,
			.navbar-inverse .navbar-nav > .active > a:focus {
			  color: #fff !important;
			  background-color: #080808 !important;
			}
			.navbar-inverse .navbar-nav > .disabled > a,
			.navbar-inverse .navbar-nav > .disabled > a:hover,
			.navbar-inverse .navbar-nav > .disabled > a:focus {
			  color: #444 !important;
			  background-color: transparent !important;
			}
			.navbar-inverse .navbar-toggle {
			  border-color: #333 !important;
			}
			.navbar-inverse .navbar-toggle:hover,
			.navbar-inverse .navbar-toggle:focus {
			  background-color: #333 !important;
			}
			.navbar-inverse .navbar-toggle .icon-bar {
			  background-color: #fff !important;
			}
			.navbar-inverse .navbar-collapse,
			.navbar-inverse .navbar-form {
			  border-color: #101010 !important;
			}
			.navbar-inverse .navbar-nav > .open > a,
			.navbar-inverse .navbar-nav > .open > a:hover,
			.navbar-inverse .navbar-nav > .open > a:focus {
			  color: #fff !important;
			  background-color: #080808 !important;
			}
			@media (max-width: 767px) {
			  .navbar-inverse .navbar-nav .open .dropdown-menu > .dropdown-header {
			    border-color: #080808 !important;
			  }
			  .navbar-inverse .navbar-nav .open .dropdown-menu .divider {
			    background-color: #080808 !important;
			  }
			  .navbar-inverse .navbar-nav .open .dropdown-menu > li > a {
			    color: #9d9d9d !important;
			  }
			  .navbar-inverse .navbar-nav .open .dropdown-menu > li > a:hover,
			  .navbar-inverse .navbar-nav .open .dropdown-menu > li > a:focus {
			    color: #fff !important;
			    background-color: transparent !important;
			  }
			  .navbar-inverse .navbar-nav .open .dropdown-menu > .active > a,
			  .navbar-inverse .navbar-nav .open .dropdown-menu > .active > a:hover,
			  .navbar-inverse .navbar-nav .open .dropdown-menu > .active > a:focus {
			    color: #fff !important;
			    background-color: #080808 !important;
			  }
			  .navbar-inverse .navbar-nav .open .dropdown-menu > .disabled > a,
			  .navbar-inverse .navbar-nav .open .dropdown-menu > .disabled > a:hover,
			  .navbar-inverse .navbar-nav .open .dropdown-menu > .disabled > a:focus {
			    color: #444 !important;
			    background-color: transparent !important;
			  }
			}
			.navbar-inverse .navbar-link {
			  color: #9d9d9d !important;
			}
			.navbar-inverse .navbar-link:hover {
			  color: #fff !important;
			}
			.navbar-inverse .btn-link {
			  color: #9d9d9d !important;
			}
			.navbar-inverse .btn-link:hover,
			.navbar-inverse .btn-link:focus {
			  color: #fff !important;
			}
			.navbar-inverse .btn-link[disabled]:hover,
			fieldset[disabled] .navbar-inverse .btn-link:hover,
			.navbar-inverse .btn-link[disabled]:focus,
			fieldset[disabled] .navbar-inverse .btn-link:focus {
			  color: #444 !important;
			}
			.container > .navbar-header,
			.container-fluid > .navbar-header,
			.container > .navbar-collapse,
			.container-fluid > .navbar-collapse {
			  margin-right: -15px !important;
			  margin-left: -15px !important;
			}
			@media (min-width: 768px) {
			  .container > .navbar-header,
			  .container-fluid > .navbar-header,
			  .container > .navbar-collapse,
			  .container-fluid > .navbar-collapse {
			    margin-right: 0 !important;
			    margin-left: 0 !important;
			  }
			}
			.nav {
			  padding-left: 0 !important;
			  margin-bottom: 0 !important;
			  list-style: none !important;
			}
			.nav > li {
			  position: relative !important;
			  display: block !important;
			}
			.nav > li > a {
			  position: relative !important;
			  display: block !important;
			  padding: 15px 15px !important;
			}
			.nav > li > a:hover,
			.nav > li > a:focus {
			  text-decoration: none !important;
			  background-color: #eee !important;
			}
			.nav > li.disabled > a {
			  color: #777 !important;
			}
			.nav > li.disabled > a:hover,
			.nav > li.disabled > a:focus {
			  color: #777 !important;
			  text-decoration: none !important;
			  cursor: not-allowed !important;
			  background-color: transparent !important;
			}
			.nav .open > a,
			.nav .open > a:hover,
			.nav .open > a:focus {
			  background-color: #eee !important;
			  border-color: #337ab7 !important;
			}
			.nav .nav-divider {
			  height: 1px !important;
			  margin: 9px 0 !important;
			  overflow: hidden !important;
			  background-color: #e5e5e5 !important;
			}
			.nav > li > a > img {
			  max-width: none !important;
			}
			.nav-tabs {
			  border-bottom: 1px solid #ddd !important;
			}
			.nav-tabs > li {
			  float: left !important;
			  margin-bottom: -1px !important;
			}
			.nav-tabs > li > a {
			  margin-right: 2px !important;
			  line-height: 1.42857143 !important;
			  border: 1px solid transparent !important;
			  border-radius: 4px 4px 0 0 !important;
			}
			.nav-tabs > li > a:hover {
			  border-color: #eee #eee #ddd !important;
			}
			.nav-tabs > li.active > a,
			.nav-tabs > li.active > a:hover,
			.nav-tabs > li.active > a:focus {
			  color: #555 !important;
			  cursor: default !important;
			  background-color: #fff !important;
			  border: 1px solid #ddd !important;
			  border-bottom-color: transparent !important;
			}
			.nav-tabs.nav-justified {
			  width: 100% !important;
			  border-bottom: 0 !important;
			}
			.nav-tabs.nav-justified > li {
			  float: none !important;
			}
			.nav-tabs.nav-justified > li > a {
			  margin-bottom: 5px !important;
			  text-align: center !important;
			}
			.nav-tabs.nav-justified > .dropdown .dropdown-menu {
			  top: auto !important;
			  left: auto !important;
			}
			@media (min-width: 768px) {
			  .nav-tabs.nav-justified > li {
			    display: table-cell !important;
			    width: 1% !important;
			  }
			  .nav-tabs.nav-justified > li > a {
			    margin-bottom: 0 !important;
			  }
			}
			.nav-tabs.nav-justified > li > a {
			  margin-right: 0 !important;
			  border-radius: 4px !important;
			}
			.nav-tabs.nav-justified > .active > a,
			.nav-tabs.nav-justified > .active > a:hover,
			.nav-tabs.nav-justified > .active > a:focus {
			  border: 1px solid #ddd !important;
			}
			@media (min-width: 768px) {
			  .nav-tabs.nav-justified > li > a {
			    border-bottom: 1px solid #ddd !important;
			    border-radius: 4px 4px 0 0 !important;
			  }
			  .nav-tabs.nav-justified > .active > a,
			  .nav-tabs.nav-justified > .active > a:hover,
			  .nav-tabs.nav-justified > .active > a:focus {
			    border-bottom-color: #fff !important;
			  }
			}
			.nav-pills > li {
			  float: left !important;
			}
			.nav-pills > li > a {
			  border-radius: 4px !important;
			}
			.nav-pills > li + li {
			  margin-left: 2px !important;
			}
			.nav-pills > li.active > a,
			.nav-pills > li.active > a:hover,
			.nav-pills > li.active > a:focus {
			  color: #fff !important;
			  background-color: #337ab7 !important;
			}
			.nav-stacked > li {
			  float: none !important;
			}
			.nav-stacked > li + li {
			  margin-top: 2px !important;
			  margin-left: 0 !important;
			}
			.nav-justified {
			  width: 100% !important;
			}
			.nav-justified > li {
			  float: none !important;
			}
			.nav-justified > li > a {
			  margin-bottom: 5px !important;
			  text-align: center !important;
			}
			.nav-justified > .dropdown .dropdown-menu {
			  top: auto !important;
			  left: auto !important;
			}
			@media (min-width: 768px) {
			  .nav-justified > li {
			    display: table-cell !important;
			    width: 1% !important;
			  }
			  .nav-justified > li > a {
			    margin-bottom: 0 !important;
			  }
			}
			.nav-tabs-justified {
			  border-bottom: 0 !important;
			}
			.nav-tabs-justified > li > a {
			  margin-right: 0 !important;
			  border-radius: 4px !important;
			}
			.nav-tabs-justified > .active > a,
			.nav-tabs-justified > .active > a:hover,
			.nav-tabs-justified > .active > a:focus {
			  border: 1px solid #ddd !important;
			}
			@media (min-width: 768px) {
			  .nav-tabs-justified > li > a {
			    border-bottom: 1px solid #ddd !important;
			    border-radius: 4px 4px 0 0 !important;
			  }
			  .nav-tabs-justified > .active > a,
			  .nav-tabs-justified > .active > a:hover,
			  .nav-tabs-justified > .active > a:focus {
			    border-bottom-color: #fff !important;
			  }
			}
			.tab-content > .tab-pane {
			  display: none !important;
			  visibility: hidden !important;
			}
			.tab-content > .active {
			  display: block !important;
			  visibility: visible !important;
			}
			.nav-tabs .dropdown-menu {
			  margin-top: -1px !important;
			  border-top-left-radius: 0 !important;
			  border-top-right-radius: 0 !important;
			}

			/*Links*/

			a {
			  background-color: transparent !important;
			}
			a:active,
			a:hover {
			  outline: 0 !important;
			}
			a,
			  a:visited {
			    text-decoration: underline !important;
			  }
			  a[href]:after {
			    content: " (" attr(href) ")" !important;
			  }
			  abbr[title]:after {
			    content: " (" attr(title) ")" !important;
			  }
			  a[href^="#"]:after,
			  a[href^="javascript:"]:after {
			    content: "" !important;
			  }
			a {
			  color: #337ab7 !important;
			  text-decoration: none !important;
			}
			a:hover,
			a:focus {
			  color: #23527c !important;
			  text-decoration: underline !important;
			}
			a:focus {
			  outline: thin dotted !important;
			  outline: 5px auto -webkit-focus-ring-color !important;
			  outline-offset: -2px !important;
			}
			a.text-primary:hover {
			  color: #286090 !important;
			}
			.text-success {
			  color: #3c763d !important;
			}
			a.text-success:hover {
			  color: #2b542c !important;
			}
			.text-info {
			  color: #31708f !important;
			}
			a.text-info:hover {
			  color: #245269 !important;
			}
			.text-warning {
			  color: #8a6d3b !important;
			}
			a.text-warning:hover {
			  color: #66512c !important;
			}
			.text-danger {
			  color: #a94442 !important;
			}
			a.text-danger:hover {
			  color: #843534 !important;
			}
			.bg-primary {
			  color: #fff !important;
			  background-color: #337ab7 !important;
			}
			a.bg-primary:hover {
			  background-color: #286090 !important;
			}
			.bg-success {
			  background-color: #dff0d8 !important;
			}
			a.bg-success:hover {
			  background-color: #c1e2b3 !important;
			}
			.bg-info {
			  background-color: #d9edf7 !important;
			}
			a.bg-info:hover {
			  background-color: #afd9ee !important;
			}
			.bg-warning {
			  background-color: #fcf8e3 !important;
			}
			a.bg-warning:hover {
			  background-color: #f7ecb5 !important;
			}
			.bg-danger {
			  background-color: #f2dede !important;
			}
			a.bg-danger:hover {
			  background-color: #e4b9b9 !important;
			}
			.page-header {
			  padding-bottom: 9px !important;
			  margin: 40px 0 20px !important;
			  border-bottom: 1px solid #eee !important;
			}

			/*SF's*/

			.apexp {
				width: 90% !important;/*65*/
				margin-left: 5% !important; /*17.5*/
			}
			body .bPageBlock, body #bodyCell .bResource .secondaryPalette, body .secondaryPalette.bPageBlock, body .individualPalette .secondaryPalette.bPageBlock, body .bodyDiv .genericTable, body .genericPageBlockTable, body .bodyDiv .bSubBlock, body .bComponentBlock .bPageBlock, body .bMyDashboard .bPageBlock, body.rlHoverFrame .bPageBlock, body.subjectSelectionPopup div.choicesBox, body.lookupTab .secondaryPalette.bPageBlock, body.popupTab .secondaryPalette.bPageBlock, body.UserTagStatsPage .secondaryPalette.bPageBlock {
				background-color: white !important;
				border-bottom: 1px solid #eaeaea !important;
				border-left: 1px solid #eaeaea !important;
				border-right: 1px solid #eaeaea !important;
				-moz-border-radius: 4px !important;
				-webkit-border-radius: 4px !important;
				border-radius: 4px !important;
			}
			body .bPageBlock {
				padding: 0 !important;
				margin-bottom: 10px !important;
				border-top-width: 3px !important;
			}
			body .bPageBlock, body .bPageBlock .pbBody, body .bPageBlock .pbBottomButtons {
				background-color: transparent !important;
				background-image: none !important;
				margin: 0 !important;
			}
			.bPageBlock .detailList tr td, .bPageBlock .detailList tr th, .hoverDetail .bPageBlock .detailList tr td, .hoverDetail .bPageBlock .detailList tr th {
				 border-bottom: 0px solid #e3deb8 !important;
			}
			.pbSubsection {
				padding-top: 10px !important;
				padding-bottom: 15px !important;
				border-bottom: 0px solid #eaeaea !important;
				border-top: 0px solid #eaeaea !important;
			}
			.bPageBlock {
				background-color: #5cb85c !important;
				border-top: 1px solid #eaeaea !important;
				margin-bottom: 9px !important;
				background-color: white !important;
				background-image: none  !important;
				background-repeat: no-repeat !important;
				background-position: left bottom !important;
				padding-bottom: 9px !important;
				clear: both !important;
			}
			.pbButtonb {
				padding: 12px 12px !important;
			}
			.pbSubheader {
				padding: 10px 0px !important;
				border-bottom: 1px solid transparent !important;
				border-top-left-radius: 3px !important;
				border-top-right-radius: 3px !important;
				border-top: 1px solid #ddd !important;
				color: #333 !important;
				background-color: #f5f5f5 !important;
				border-color: #ddd !important;
				border-top-color: #ddd !important;
				height: 40px !important;
				width: 100% !important;
			    font-weight: bold !important;
				font-size: 100% !important;
				margin-top: 0px !important;
				overflow: hidden !important;
				margin-bottom: 0px !important;
				text-align: center !important;
			}
			div .pbSubheader > img {
				opacity: 0.5 !important;
				filter: invert(1) !important;
				-webkit-filter: invert(1) !important;
				-moz-filter: invert(1) !important;
				-o-filter: invert(1) !important;
				-ms-filter: invert(1) !important;
				-webkit-transform: scale(1.4) !important;
			  	-moz-transform: scale(1.4) !important;
			  	-o-transform: scale(1.4) !important;
			  	transform: scale(1.4) !important;
				margin-bottom: 3px !important;
				image-rendering:  optimizeQuality !important;
				border: none !important;
				-moz-user-select: none !important;
				 -webkit-user-select: none !important;
				 -ms-user-select: none !important;
				 user-select: none !important;
			}
			div .pbSubheader > img:link, img:visited, img:hover, img:focus, img:active {
				border: 0 !important;
				outline: 0 !important;
			}
			div .pbSubheader > img:hover {
				opacity: 0.9 !important;
				-webkit-transform: scale(1.6) !important;
			  	-moz-transform: scale(1.6) !important;
			  	-o-transform: scale(1.6) !important;
			  	transform: scale(1.6) !important;
			}
			div .pbSubheader > h3 {
				font-size: 30px !important;

			}
			body, td {
				font-family: Arial,Helvetica,sans-serif !important;
				color: #222 !important;
			}
			body {
				background-repeat: repeat-x !important;
				background-position: left top !important;
				font-size: 75% !important;
				font-family: 'Arial','Helvetica',sans-serif !important;
				background-color: #fff !important;
			}
			body, td {
				margin: 0 !important;
				color: #333 !important;
			}
			.labelCol {
				font-size: 18px !important;
				font-weight: normal !important;
				color: #777 !important;
				max-width: 100% !important;
				margin-bottom: 5px !important;
				padding: .2em .6em .3em .2em !important;
				white-space: nowrap !important;
				vertical-align: baseline !important;
				border-radius: .25em !important;
				margin: .2em .2em .2em .2em !important;
				vertical-align: middle !important;
			}
			.data2Col {
				vertical-align: middle !important;
				padding: 6px 12px !important;
				font-size: 14px !important;
				color: #555 !important;
			}
			.data2Col > span {
				display: block !important;
				width: 97.6% !important;
				/*height: 34px !important;*/
				padding: 6px 12px !important;
				font-size: 14px !important;
				line-height: 1.42857143 !important;
				color: #555 !important;
				background-color: #fff !important;
				background-image: none !important;
				border: 1px dotted #ccc !important;
				border-radius: 4px !important;
				-webkit-box-sizing: border-box !important; /* Safari/Chrome, other WebKit */
			    -moz-box-sizing: border-box !important;    /* Firefox, other Gecko */
			    box-sizing: border-box !important;
			}
			.data2Col > .dateInput {
				width: 100% !important;
				border: none !important;
				padding: 0px !important;
			}
			.data2Col > .dateInput > input {
				margin-left: 1.2% !important;
			}
			.multiSelectPicklistRow > td > select {
				margin: 6px 12px !important;
			}
			.multiSelectPicklistRow > .multiSelectPicklistCell {
				text-align: right !important;
			}
/*			.dateBar > select #calMonthPicker {
				display: inline !important;
				margin: 0px !important;
				width: 83% !important;
			}*/
/*			.dateBar > select #calYearPicker {
				margin: 0px !important;
				width: 83% !important;
			}*/
			.dateBar > img {
				display: none !important;
			}
			.dateInput > .dateFormat {
				margin-left: 12px !important;
			}
			.sfdc_richtext > img {
				max-width: 100% !important;
			}
			span:empty {
				display: none !important;
			}
			.waitingSearchDiv {
				position: fixed !important;
			}
			.waitingSearchDiv .waitingHolder {
				width: 60% !important;				
			}
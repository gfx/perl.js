var Module = {
	noInitialRun: true,
	noExitRuntime: true,
	arguments: ["--version"]
	//preInit: [], // called once
	//preRun:  [], // called before every run()
};

if (typeof jQuery !== "undefined") { // for the web
	jQuery(function($) {
		function output(s) {
			var output = $('#output');
			output.val(output.val() + s + "\n");
		}
		function onOutput(c) {
			var o = $('#output');
			o.val(o.val() + String.fromCharCode(s));
		}
		function onInput() {
			return null; // EOF
		}
		Module.stdin  = onInput;
		Module.stdout = onOutput;
		Module.stderr = onOutput;
		Module.print  = output;
		Module.printErr = output;
		Module.exit = function exit(status) {
			EXITSTATUS = status;
			STACKTOP = initialStackTop;
			throw new ExitStatus(status);
		};

		$('#output').val(sessionStorage.getItem('output'));

		$('#eval').click(function() {
			sessionStorage.removeItem('output');
			$('#output').val('');
			preloadStartTime = null;
			ABORT = false;
			try {
				try { FS.unlink('/input') } catch (e) { }
				FS.createDataFile('/', 'input', $('#input').val(), true, true);
				Module.callMain(['/input']);
			} catch (err) {
				output(err.message || err.toString());
			}
			finally {
				var src = encodeURIComponent($('#input').val());
				location.hash = src;
			}
		});

		var src = location.hash;
		if (src) {
			$('#input').val(decodeURIComponent(src.slice(1)));
			$('#eval').trigger('click');
		}
		else {
			$('#input').val(
				"use strict;\n" +
				"use warnings;\n" +
				"\n" +
				"print \"Hello, perl.js!\\n\"\n");
			Module.callMain(['--version'])
		}


		// monky patch
		Module.abort = abort = function abort(text) {
			setTimeout(function () {
				alert('abort() called, reloading.');
				window.location.reload();
			}, 0);
			sessionStorage.setItem('output', $('#output').val());
			Module.exit(1);
		};
	});
}

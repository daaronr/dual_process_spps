$( document ).ready(function() {


	/* For calculators on ratings pages */

	function numberWithCommas(x) {
    	return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}

	function roundSpecial(x) {
		x = Math.round(x)
		y = Math.round(x / Math.pow(10, x.toString().length-1)) * Math.pow(10, x.toString().length-1)

		return y
	}

	$(".search-donate-amount").keyup(function() {
		if($.isNumeric($(this).val())) {
			if($(this).val() > 1000000) {
				$("#" + $(this).data("target")).html("Giving away " + numberWithCommas($(this).val()) + "? We should probably just talk.")
			}
			else {
				format = $(this).data("statement-format");
				if(format == 2) {
					multiple = $(this).val()/$(this).data("cost-per-unit-of-impact")
					if(multiple < 1) {
						output = "Pooled with " + numberWithCommas(Math.round($(this).data("cost-per-unit-of-impact")/$(this).val())) + " others, your donation of $" + numberWithCommas($(this).val()) + " " + $(this).data("statement") + "."
					} else if(multiple < 1.5) {
						output = "Your donation of $" + numberWithCommas($(this).val()) + " " + $(this).data("statement") + "."
					} else {
						output = "Your donation of $" + numberWithCommas($(this).val()) + " " + $(this).data("statement-plural").replace("{number}", numberWithCommas(Math.round(multiple))) + "."
					}
					$("#" + $(this).data("target")).html(output)
				}
				if(format == 1) {
					amount = ($(this).val() / $(this).data("cost-per-participant")) * $(this).data("impact-per-participant")
					output = "Your donation of $" + numberWithCommas($(this).val()) + " " + $(this).data("statement") + " by $" + numberWithCommas(roundSpecial(amount)) + "."
					$("#" + $(this).data("target")).html(output)
				}
			}
		}
		if($(this).val() == "") {
			$("#" + $(this).data("target")).html("Enter an amount to calculate your impact.")
		}
	})


	/* For evaluation tips */

	$(".evaluation-tips .evaluation-tip").hide();
	tips = [1,2,3,4,5,6,7,8,9]
	evaluationTip = tips[Math.floor(Math.random() * tips.length)]
	tipsWorking = tips.slice()
	tipsWorking.splice(tipsWorking.indexOf(evaluationTip),1)
	console.log(tipsWorking)
	$("#tip-" + evaluationTip).show();
	$(".evaluation-tip-rotator").click(function() {
		console.log(tipsWorking)
		$("#tip-" + evaluationTip).hide();
		if(tipsWorking.length == 0) {
			console.log("asdf")
			tipsWorking = tips.slice()
		}
		evaluationTip = tipsWorking[Math.floor(Math.random() * tipsWorking.length)]
		tipsWorking.splice(tipsWorking.indexOf(evaluationTip),1)
		$("#tip-" + evaluationTip).fadeToggle();
		console.log(tipsWorking)
		
	});

});
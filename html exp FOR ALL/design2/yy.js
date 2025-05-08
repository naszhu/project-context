      var v_countingsum = {
        type: jsPsychSurveyText,
        questions: [
          {prompt: 'Please enter the sum using your number keyboard'}
        ],
        post_trial_gap: 100,
        data: {
          task: "counting_response",
          correct_response: digits_list_sum
        },
        on_finish: function(data){
          isdigits = /^\d+$/.test(data.response)
          if (!isdigits){
                        // console.log("not digits")
            var messageDiv = document.createElement("div");
            messageDiv.innerHTML = `<div style="text-align:center ; font-size: larger; font-weight: bold; color: black;"><br> <br> <br> <br> <br>NOT digits!</div>`;
            document.body.prepend(messageDiv);
            var exp = document.getElementsByClassName("jspsych-content-wrapper")[0]
            exp.style.visibility = "hidden";
            setTimeout(function() {
            document.body.removeChild(messageDiv); // Remove the div
            exp.style.visibility = "visible";
            jsPsych.resumeExperiment();
            }, 1500);//remove after 1.5s

          }
        }
      };
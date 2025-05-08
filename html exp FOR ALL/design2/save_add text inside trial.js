
        // Add placeholders for feedback after each question
        var htmlContent = "<div id='feedback1'></div><div id='feedback2'></div>";
        document.querySelector("#jspsych-survey-text-next").insertAdjacentHTML('beforebegin', htmlContent);
        console.log(document.querySelector("#jspsych-survey-text-next"))

        var messageDiv = document.createElement("div");
        messageDiv.setAttribute("id", "Div1");
        messageDiv.innerHTML = "";
        console.log(messageDiv)

        
        // Parse the response from the survey
        // var responses = JSON.parse(data.responses);

        // Generate feedback based on the responses
        // var feedback1 = responses.Q1.toLowerCase().includes("happy") ? "Glad you are feeling happy!" : "Hope you feel better soon!";
        // var feedback2 = responses.Q2.toLowerCase() === "eggs" ? "Eggs are a great choice for breakfast!" : "Interesting breakfast choice!";

        // Update the feedback placeholders with actual feedback
        console.log(document.getElementById('feedback1'))
        document.getElementById('DIV1').innerHTML = "Ssss";
        // document.getElementById('feedback2').innerHTML = "Ssss";



        var temptest = {type:jsPsychHtmlKeyboardResponse,
                stimulus:function(){
                    return "ss".concat(jsPsych.timelineVariable("face"))
                },
            on_start: function(){
                var messageDiv = document.createElement("div");
                messageDiv.setAttribute("id", "Div1");
                messageDiv.innerHTML = "";
                                    messageDiv.style.textAlign = "center";
                            messageDiv.style.margin = "0px"
                            messageDiv.style.justifyContent = "center";
                            document.body.prepend(messageDiv);
                console.log(messageDiv)
        
        
            },
            on_load:function(){
                var htmlContent = "<div id='feedback1'></div><div id='feedback2'></div>";
                document.querySelector(".jspsych-content-wrapper").insertAdjacentHTML('beforebegin', htmlContent);
                console.log(document.querySelector("#jspsych-survey-text-next"))
            },
            on_finish:function(){
                if (itemp==1){
                    console.log( document.getElementById('feedback1'))
                    document.getElementById('feedback1').innerHTML = "Ssss";
                }
                itemp++
                console.log(itemp)
            }
            }
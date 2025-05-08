    var finaltest_feedback = {
    on_start: function(trial){
        is_showcorrect_inlog? console.log("feedback",jsPsych.data.get().last(1).values()[0]) : null
    },
    type: jsPsychHtmlKeyboardResponse,
    stimulus: function(){

        answer1=`<FONT color="grey"><p style="line-height: 1.5;">`.concat(`Type <strong>the whole word</strong> you studied in <strong>ALL</strong> previous lists, starting with <strong>"`,ftlnow,`</strong>`,`________"</p> <p style="line-height: 1.5;">
        Press 'enter' key to go to next blank or next cues</p>`,`<p style="line-height: 1.3;">The first word if you remember:</p></FONT>`);

        answer2=`<FONT color="grey"><p style="line-height: 1.3;">The second word if you remember:</p></FONT>`;

        lasttrial_obj = jsPsych.data.get().last(1).values()[0];
        if (lasttrial_obj.rt>20000) {feed_note0 = `<br><strong> Please respond faster!!</strong> <br>`; lasttrial_obj.is_tooslow=1}
        else{ feed_note0="";  lasttrial_obj.is_tooslow=0}

        // iscorrect1 = lasttrial_obj.is_correct_first ? "CORRECT! " : "INCORRECT! ";
        // iscorrect2 = lasttrial_obj.is_correct_second ? "CORRECT! " : "INCORRECT! ";
        // iscorrect1 = lasttrial_obj.word1_response==='none' ? '     ' : iscorrect1; 
        // iscorrect2 = lasttrial_obj.word2_response==='none' ? '     ' : iscorrect2; 
        
        iscorrect1 = lasttrial_obj.is_correct_first ? `<FONT color='#CC5500'>CORRECT! </FONT>` : "INCORRECT! ";
        iscorrect2 = lasttrial_obj.is_correct_second ? "CORRECT! " : "INCORRECT! ";
        concatfont = struse=>''.concat(`<FONT color='#CC5500'>`,struse,`</FONT>`)
        iscorrect1 = ''.concat(`<FONT color='#CC5500'>`,iscorrect1,`</FONT>`);
        iscorrect2 = ''.concat(`<FONT color='#CC5500'>`,iscorrect2,`</FONT>`);
        iscorrect1now=iscorrect1;iscorrect2now=iscorrect2;



        
        iscorrect2 = lasttrial_obj.word2_response==='none' && lasttrial_obj.is_correct_second? ''.concat(iscorrect2, "", concatfont("NO second word "), "was studied") : iscorrect2; 
        iscorrect2 = lasttrial_obj.word2_response==='none' && !lasttrial_obj.is_correct_second? ''.concat(iscorrect2, "There was ", concatfont("a second word "), "studied") : iscorrect2; 

        //when first word is not none, second word is also not none but unique condition
        if (lasttrial_obj.word1_response!=='none' && lasttrial_obj.word2_response!=='none' && !lasttrial_obj.is_correct_second && lasttrial_obj.wordcondi==="unique") {
            // iscorrect2=iscorrect2.concat("There is no second word studied!");
            iscorrect2=''.concat(iscorrect2, "", concatfont("NO second word "), "was studied")
        }

        if (lasttrial_obj.word1_response==='none'){
            // console.log(lasttrial_obj.word1_response,lasttrial_obj.word1_response!=='none')
            if (lasttrial_obj.word2_response!=='none') iscorrect1 = "Please prioritize in filling in the first blank"
            else if (lasttrial_obj.word2_response==='none') {
                iscorrect1 = " ";
                iscorrect2 = " ";
            }
        }

        if (lasttrial_obj.wordcondi==="unique"&&lasttrial_obj.is_repeat_word2_reverse){
            iscorrect1=''.concat(iscorrect1, "There is ", concatfont("NO second word "), "studied")
        }

        
        // responsefeed1 = ``.concat(answer1,`<p style="margin-bottom: 42px;">`,"Answer:<u> <strong>",lasttrial_obj.word_response_original[0], ` </u></strong>&nbsp&nbsp&nbsp&nbsp<strong>`,iscorrect1,`</strong></p>`)
        // responsefeed2 = ``.concat(answer2,`<p style="margin-bottom: 23px;">`,"Answer:<u> <strong>", lasttrial_obj.word_response_original[1],` </u></strong>&nbsp&nbsp&nbsp&nbsp<strong>`,iscorrect2,`</strong></p>`)
        responsefeed1 = ``.concat(answer1,`<p style="margin-bottom: 42px;">`,"Answer:<u> <strong>",lasttrial_obj.word_response_original[0], ` </u></strong>&nbsp&nbsp&nbsp&nbsp<strong>`,iscorrect1now,`</strong></p>`)
        responsefeed2 = ``.concat(answer2,`<p style="margin-bottom: 23px;">`,"Answer:<u> <strong>", lasttrial_obj.word_response_original[1],` </u></strong>&nbsp&nbsp&nbsp&nbsp<strong>`,iscorrect2now,`</strong></p>`)
        // console.log(lasttrial_obj.wordchosen_finaltest)
        // console.log(capitalizeStringinArr(lasttrial_obj.wordchosen_finaltest))
        return ``.concat(responsefeed1,``,responsefeed2,'')
    },
    data:{
        task: 'finalt_feedback',
        ftl: JT('ftl'),
        is_test: JT('is_test'),
        is_test_inpair: JT('is_test_inpair'),
        is_test_inpair1: JT('is_test_inpair1'),
        is_test_inpair2: JT('is_test_inpair2'),
        listgroup_1to5: JT('listgroup_1to5'),
        listnumber_1to10: JT('listnumber_1to10'),
        listnumber_1to10_inpair1 : JT('listnumber_1to10_inpair1'),
        listnumber_1to10_inpair2 : JT('listnumber_1to10_inpair2'),
        pairs_which_1or2: JT('pairs_which_1or2'),
        prespos: JT('prespos'),
        prespos_inpair1: JT('prespos_inpair1'),
        prespos_inpair2: JT('prespos_inpair2'),
        testpos_pretest: JT('testpos_pretest'), 
        testpos_final: JT('testpos_final'),
        testpos_inpair: JT('testpos_inpair'), 
        testpos_inpair1: JT('testpos_inpair1'), 
        testpos_inpair2: JT('testpos_inpair2'), 
        word_left_i: JT('word_left_i'),
        word_right_i: JT('word_right_i'),
        wordchosen_initial: JT('wordchosen_initial'),
        wordchosen_finaltest: JT('wordchosen_finaltest'), 
        wordchosen_inpair1: JT('wordchosen_inpair1'), 
        wordchosen_inpair2: JT('wordchosen_inpair2'), 
        wordcondi: JT('wordcondi')
        // trialnum: 
    },
    trial_duration: feedbackmes_wordfinal_duration,
    choices:"NO_KEYS",
    post_trial_gap: posgap_duration
    // choices:"enter"
    }
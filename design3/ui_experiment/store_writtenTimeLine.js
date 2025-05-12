const initialTest_timeline = all_lists_initialStudy_inUse.map(function(list,list_ind){
    return {
        timeline: [
            {
                timeline: list_ind === 0 ? [prompt_instructions_practice] : [prompt_instructions_between]
            },
            {
                timeline: [fixation]
            },
            {//The following are comparable to push the 'final' stuff into the timeline variable; as if creating a new timeline varible element
                timeline: [v_initialstudy_trial],
                timeline_variables: list.studies
            },
            {
                timeline: [prompt_digits]
            },
            {
                timeline: [fixation]
            },
            {
                timeline: [v_digitpresent],
                timelineVariable: list.digits
            },
            {
                timeline: [answer_digit_looptrial]
            },                    
            {
                timeline: [prompt_recall]
            },                    
            {
                timeline: [fixation]
            },                    
            {
                timeline: [v_initialtest_trial,prompt_initialtest_feedback],
                timelineVariable: list.tests
            }
        ]
    };
});
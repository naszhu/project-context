

var j_final=0;
for (let i_list=0;i_list<10;i_list++){


    if_pair1 = i_list%2==0
    if (if_pair1) {
        arobj_current = tot_word_arobj_nf_rd[i_list]
        arobj_pair = tot_word_arobj_nf_rd[i_list+1]
    }
    else{
        arobj_current = tot_word_arobj_nf_rd[i_list]
        arobj_pair = tot_word_arobj_nf_rd[i_list-1]
    }

    for (let j=0;j<20;j++){

        obj_current = arobj_current[j];
        ftl_oppos_indexinpair = range(0,20).map(inow=>arobj_pair[inow].ftl).findIndex(x=>x==obj_current.ftl); // for each 1, find index in array 2

        if (obj_current.wordcondi=="repeat"){
            correspond_obj_inpair = arobj_pair[ftl_oppos_indexinpair];
            if (correspond_obj_inpair.is_test==1) obj_current.istest_inpair=1; 
            else obj_current.istest_inpair=0; 

            obj_current.testpos_inpair=correspond_obj_inpair.testpos;
            obj_current.prespos_inpair=correspond_obj_inpair.prespos;
            
            if (if_pair1) {
                pair1 = obj_current;
                pair2 = correspond_obj_inpair;
            } else {
                pair1 = correspond_obj_inpair;
                pair2 = obj_current;
            }

 
            obj_current.wordchosen_inpair1 = pair1.word_left_i;
            obj_current.wordchosen_inpair2 = pair1.word_right_i;
            obj_current.wordchosen_finaltest = [pair1.word_left_i,pair1.word_right_i];
  
            

            if (if_pair1) {
                obj_current.testpos_final=finalt_ind[i_list][j_final];
                j_final++
            }
            else {
                obj_current.testpos_final=correspond_obj_inpair.testpos_final;
            }

        } else if(obj_current.wordcondi=="unique"){
            obj_current.testpos_final=finalt_ind[i_list][j_final];
            j_final++;
            obj_current.wordchosen_finaltest = [obj_current.wordchosen];
        }
    }
}
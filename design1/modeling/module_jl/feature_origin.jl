########### Z feature functions here (aligned with E3)
function update_Z_feature_study!(word::Word, list_number::Int64)::Nothing
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        # κ parameters start from list 2, so κ[1] = list 2, κ[2] = list 3, etc.
        # For list 1, use base κu value (no asymptotic effect yet)
        if list_number === 1
            κ_value = ku_base # this number doesn't matter because first list won't use Z
        else
            κ_index = list_number - 1
            κ_value = κu[κ_index]
        end

        # Set Z feature value based on κu probability
        word.word_features[tested_before_feature_pos] = rand() < κ_value ? 1 : 0
    end
    return nothing
end

function get_Z_feature_value(word::Word)::Int64
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        return word.word_features[tested_before_feature_pos]
    else
        return 0
    end
end

function set_Z_feature_value!(word::Word, value::Int64)::Nothing
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        word.word_features[tested_before_feature_pos] = value
    end
    return nothing
end

"""
Update Z feature for recalled+new case (confusing foil - list version used).
For strengthened trace: Replace Z=0 with KB, keep Z=1 as is
"""
function update_Z_feature_recalled_new_strengthen!(word::Word, list_number::Int64)::Nothing
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        current_z = word.word_features[tested_before_feature_pos]

        # If Z = 0 (incorrect/missing) → Replace with KB
        if current_z == 0
            # κ parameters: for list 1 use base, else use array
            if list_number === 1 || list_number === 0
                κ_value = kb_base
            else
                κ_index = list_number - 1
                κ_value = κb[κ_index]
            end

            # Only replace if original value is 0, keep 1 if it was already 1
            if word.word_features[tested_before_feature_pos] == 0
                word.word_features[tested_before_feature_pos] = rand() < κ_value ? 1 : 0
            end
        end
        # If Z = 1 → Keep as 1 (no change needed)
    end
    return nothing
end

"""
Update Z feature for recalled+new case when adding new trace.
Store Z = 1 with probability KB
"""
function update_Z_feature_recalled_new_add_trace!(word::Word, list_number::Int64)::Nothing
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        # κ parameters: for list 1 use base, else use array
        if list_number === 1 || list_number === 0
            κ_value = kb_base
        else
            κ_index = list_number - 1
            κ_value = κb[κ_index]
        end

        word.word_features[tested_before_feature_pos] = rand() < κ_value ? 1 : 0
    end
    return nothing
end

"""
Update Z feature for recalled+old case.
Store Z = 1 with probability KB (both strengthening and adding trace)
"""
function update_Z_feature_recalled_old!(word::Word, list_number::Int64)::Nothing
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        # κ parameters: for list 1 use base, else use array
        if list_number === 1 || list_number === 0
            κ_value = kb_base
        else
            κ_index = list_number - 1
            κ_value = κb[κ_index]
        end

        word.word_features[tested_before_feature_pos] = rand() < κ_value ? 1 : 0
    end
    return nothing
end

"""
Update Z feature for not recalled+new case (really new foil).
Add new trace with Z = 1 with probability KT
"""
function update_Z_feature_not_recalled_new!(word::Word, list_number::Int64)::Nothing
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        # κ parameters: for list 1 use base, else use array
        if list_number === 1 || list_number === 0
            κ_value = kt_base
        else
            κ_index = list_number - 1
            κ_value = κt[κ_index]
        end

        word.word_features[tested_before_feature_pos] = rand() < κ_value ? 1 : 0
    end
    return nothing
end

"""
Update Z feature for not recalled+old case (target with no trace recalled).
Add trace with Z = 1 with probability KB
"""
function update_Z_feature_not_recalled_old!(word::Word, list_number::Int64)::Nothing
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        # κ parameters: for list 1 use base, else use array
        if list_number === 1 || list_number === 0
            κ_value = kb_base
        else
            κ_index = list_number - 1
            κ_value = κb[κ_index]
        end

        word.word_features[tested_before_feature_pos] = rand() < κ_value ? 1 : 0
    end
    return nothing
end

"""
Update Z features for all studied-only items between lists.
This function identifies items that appeared only once in previous lists (studied-only)
and excludes items that appeared multiple times (double-appeared = studied + tested before).
Only studied-only items get Z=1 with probability KS.
"""
function update_Z_features_single_appearance_studied_items!(
    image_pool::Vector{EpisodicImage},
    studied_pool::Vector{Vector{EpisodicImage}},
    list_num::Int64,
    n_studyitem::Int64
)::Nothing

    for img in image_pool
        # Check if this image is from the current list (not a foil)
        if img.list_number == list_num
            # Check if this is a studied item (not a foil) by looking at its position in studied_pool
            # Studied items are in positions 1:n_studyitem
            is_studied_item = false
            for j in 1:n_studyitem
                if !isnothing(studied_pool[list_num][j]) &&
                   studied_pool[list_num][j].word.item == img.word.item
                    is_studied_item = true
                    break
                end
            end

            # If it's a studied item, check how many times it appeared
            if is_studied_item
                appearance_count = 0
                for list_idx in 1:list_num
                    if !isnothing(studied_pool[list_idx])
                        for item in studied_pool[list_idx]
                            if !isnothing(item) && item.word.item == img.word.item
                                appearance_count += 1
                            end
                        end
                    end
                end

                # If the item appears only once (studied-only, not double-appeared), update its Z feature
                if appearance_count == 1
                    update_Z_feature_between_lists_studied_only!(img.word, list_num)
                end
            end
        end
    end

    return nothing
end

"""
Update Z features for studied-only items between lists.
All studied-only features are updated with Z=1 with probability KS.
"""
function update_Z_feature_between_lists_studied_only!(word::Word, list_number::Int64)::Nothing
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        # Use KS parameter for studied-only items between lists
        if list_number === 1 || list_number === 0
            κ_value = ks_base
        else
            κ_index = list_number - 1
            κ_value = κs[κ_index]
        end

        word.word_features[tested_before_feature_pos] = rand() < κ_value ? 1 : 0
    end
    return nothing
end

"""
Update Z feature for target restoration (same as recalled+old case).
Store Z=1 with probability KB.
"""
function update_Z_feature_target_restoration!(word::Word, list_number::Int64)::Nothing
    update_Z_feature_recalled_old!(word, list_number)
    return nothing
end


"""
Update Z feature for recalled+new case when adding new trace.
Store Z = 1 with probability KB
"""
function update_Z_feature_recalled_new_add_trace!(word::Word, list_number::Int64)::Nothing
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        # κ parameters: for list 1 use base, else use array
        if list_number === 1 || list_number === 0
            κ_value = kb_base
        else
            κ_index = list_number - 1
            κ_value = κb[κ_index]
        end

        word.word_features[tested_before_feature_pos] = rand() < κ_value ? 1 : 0
    end
    return nothing
end

"""
Update Z feature for recalled+old case.
Store Z = 1 with probability KB (both strengthening and adding trace)
"""
function update_Z_feature_recalled_old!(word::Word, list_number::Int64)::Nothing
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        # κ parameters: for list 1 use base, else use array
        if list_number === 1 || list_number === 0
            κ_value = kb_base
        else
            κ_index = list_number - 1
            κ_value = κb[κ_index]
        end

        word.word_features[tested_before_feature_pos] = rand() < κ_value ? 1 : 0
    end
    return nothing
end

"""
Update Z feature for not recalled+new case (really new foil).
Add new trace with Z = 1 with probability KT
"""
function update_Z_feature_not_recalled_new!(word::Word, list_number::Int64)::Nothing
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        # κ parameters: for list 1 use base, else use array
        if list_number === 1 || list_number === 0
            κ_value = kt_base
        else
            κ_index = list_number - 1
            κ_value = κt[κ_index]
        end

        word.word_features[tested_before_feature_pos] = rand() < κ_value ? 1 : 0
    end
    return nothing
end

"""
Update Z feature for not recalled+old case (target with no trace recalled).
Add trace with Z = 1 with probability KB
"""
function update_Z_feature_not_recalled_old!(word::Word, list_number::Int64)::Nothing
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        # κ parameters: for list 1 use base, else use array
        if list_number === 1 || list_number === 0
            κ_value = kb_base
        else
            κ_index = list_number - 1
            κ_value = κb[κ_index]
        end

        word.word_features[tested_before_feature_pos] = rand() < κ_value ? 1 : 0
    end
    return nothing
end

function update_Z_feature_for_decision!(word::Word, recalled::Bool, answer_old::Bool, is_target::Bool, list_number::Int64)::Nothing
    if recalled && !answer_old
        # Case 1: RECALLED + Answer NEW (confusing foil)
        update_Z_feature_recalled_new_add_trace!(word, list_number)
    elseif recalled && answer_old
        # Case 2: RECALLED + Answer OLD
        update_Z_feature_recalled_old!(word, list_number)
    elseif !recalled && !answer_old
        # Case 3: NOT RECALLED + Answer NEW (really new foil)
        update_Z_feature_not_recalled_new!(word, list_number)
    elseif !recalled && answer_old
        # Case 4: NOT RECALLED + Answer OLD (target with no trace recalled)
        update_Z_feature_not_recalled_old!(word, list_number)
    end
    return nothing
end

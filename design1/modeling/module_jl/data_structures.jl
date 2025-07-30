



#===============================================
===============================================#
# Data Structures                         
struct Word
    item::String
    word_features::Vector{Int64}
    type::Symbol
    studypos::Int64
end


mutable struct EpisodicImage
    word::Word
    context_features::Vector{Int64}
    list_number::Int64
    initial_testpos_img::Int64
    # function EpisodicImage(word::Word,context_features::Vector{Int64},list_number::Int64, initial_testpos_img::Int64=0)
    #     return EpisodicImage(word, context_features, list_number, initial_testpos_img)
    # end
end

ceil(Int, 43 / 42)
ceil(Int, (43 - 1) / 42)

struct Probe
    image::EpisodicImage
    classification::Symbol  # :target or :test
    initial_testpos::Int64
    # initial_studypos::Int64
    
end

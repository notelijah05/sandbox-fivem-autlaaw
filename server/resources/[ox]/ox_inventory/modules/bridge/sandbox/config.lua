return {
    StartItems = {
        {
            name = "govid",
            count = 1,
            metadata = function(_, charData)
                return {
                    Name = string.format("%s %s", charData.First, charData.Last),
                    Gender = charData.Gender == 1 and "Female" or "Male",
                    PassportID = charData.User,
                    StateID = charData.SID,
                    DOB = charData.DOB,
                    Mugshot = charData.Mugshot
                }
            end,
        },
        {
            name = "phone",
            count = 1
        },
        {
            name = "water",
            count = 5
        },
        {
            name = "sandwich_blt",
            count = 5
        },
        {
            name = "bandage",
            count = 5
        },
        {
            name = "coffee",
            count = 2
        },
    }
}

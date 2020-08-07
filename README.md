# Photogram Signin

[Here is your target.](http://photogram-signin.matchthetarget.com)

**Follow along with the walkthrough video on Canvas.**
 
## Specs
<details>
  <summary>Click here to see names of each test</summary>

/users/[USERNAME] - Update user form does not display Update user form when logged in user is on another user's page

/users/[USERNAME] - Update user form does display Update user form when logged in user is on their own page

/photos - Create photo form automatically populates owner_id of new photo with id of the signed in user

/photos/[ID] - Update photo form does not display Update photo form when photo does not belong to current user

/photos/[ID] - Update photo form displays Update photo form when photo belongs to current user

/photos/[ID] - Delete this photo button displays Delete this photo button when photo belongs to current user

/photos/[ID] — Add comment form automatically associates comment with signed in user and current photo

/photos/[ID] - Like Form automatically populates photo_id and fan_id with current photo and signed in user

/photos/[ID] - Delete Like link displays 'Delete Like' link if current user has already liked the Photo

/photos/[ID] - Delete Like link removes the Like record between the current user and current photo when clicked

</details>

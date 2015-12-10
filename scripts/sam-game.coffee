class Game
  @currentQ = null
  index = 0
  questionAnswerJSON = [
    {
        "answer": "7", 
        "question": "Un certain câble plus pâle (quoique de la même couleur) que les autres va de 99 à...?", 
    },
    {
        "answer": "29", 
        "question": "Trouvez cet endroit! http://imgur.com/RNTvYUJ", 
    },
    {
        "answer": "12.11", 
        "question": "@psenechal insérer énigme de Pinball ici", 
    },
    {
        "answer": "16", 
        "question": "Il faut maintenant se connecter en tant que pinball sur le serveur ubiquicast qui diffuse le signal linéaire suivant: http://demo.stingray.com/en/demos/concert.php et trouver le nombre magique.", 
    },
    {
        "answer": "VIB_N0162", 
        "question": "@psenechal insérer énigme de Vibes Search ici", 
    },
    {
        "answer": "1612678", 
        "question": "Avec tous les indices recueillis, vous avez tous ce qui faut pour fournir la prochaine réponse...", 
    },
    {
        "answer": "BEER", 
        "question": "Félicitations! Maintenant que vous avez trouvé la réponse, vous devriez en prendre bonne NOTE", 
    }
  ]
  constructor: (@robot) ->
    @robot.logger.debug "Initiated sam game script."
    
  askQuestion: (resp, index) ->
    unless @currentQ # set current question
      @currentQ = questionAnswerJSON[index]
      @robot.logger.debug "#{@currentQ.answer}"
      @currentQ.validAnswer = @currentQ.answer

    text = @currentQ.question
    if index == 6
      resp.send "LAST QUESTION ----> #{text} \n"
    else	
      resp.send "NEXT QUESTION ----> #{text} \n\n"+
      "(Answer with !a [answer] or !answer [answer])"
  
  answerQuestion: (resp, guess) ->
    if @currentQ
      checkGuess = guess.toLowerCase()
      # remove all punctuation and spaces, and see if the answer is in the guess.
      checkAnswer = @currentQ.validAnswer.toLowerCase()

      if checkGuess == checkAnswer
        name = resp.envelope.user.name.toLowerCase().trim()
        resp.reply "YOU ARE CORRECT!!! The answer is #{@currentQ.answer} "
        index++
        @currentQ = null
        @hintLength = null
        @robot.logger.debug "#{name} answered correctly."
        @askQuestion(resp, index)
      else
        resp.send "#{guess} is incorrect. TRY HARDER!!"
    else
      resp.send "There is no active question!"

module.exports = (robot) ->
  game = new Game(robot)
  robot.respond /open the (.*) doors/i, (res) ->
    doorType = res.match[1]
    if doorType is "pod bay"
      res.reply "I'm afraid I can't let you do that."
    else
      res.reply "Opening #{doorType} doors"

  startGame = false
  gameStarted = false

  get_username = (response) ->
    "@#{response.message.user.name}"
  
  robot.respond /start/i, (res) ->
    res.send '@nlewis @jean @gblain @lthibault @fcontant do you want to play a game?'
    gameStarted = true
    return

  robot.respond /yes/i, (res) ->
    if gameStarted
      user = get_username(res)
      if user == '@nlewis' || user == '@lthibault' || user == '@gblain' || user == '@jean' || user == '@fcontant'
        res.send "Let the hunt begin muhuhaha"
        game.askQuestion(res, 0)
      else
        res.send "you cannot play this game. Only @nlewis, @ltibault, @fcontant and @gblain can play!"
    return

  robot.hear /^!a(nswer)? (.*)/, (resp) ->
    game.answerQuestion(resp, resp.match[2])

  robot.hear /gblain/i, (res) ->
    res.send 'oh man that @gblain is fierce like beyonce'
    return
    
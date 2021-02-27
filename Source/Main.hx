package;

import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.events.Event;
import openfl.events.MouseEvent;

class Main extends Sprite
{
  final letters = ['a','b','c','d','e','f','g','h'];
  final numbers = [for (i in 0...8) "" + (i+1)];
  final buttonText = "Click for Chess Square";
  var format:TextFormat;
  var button:TextField;
  var squareField:TextField;
  var answerField:TextField;

  var revealMode = {};
  var generateMode = {};
  var mode:{};

  
  function randomSquare () {
    var letter = Math.floor(Math.random() * 8);
    var number = Math.floor(Math.random() * 8);
    var color = if ((letter + number) % 2 == 0) "Black" else "White";
    var val =  {code: letters[letter] + numbers[number], color: color};
    return val;
  }

  public function new()
  {
    super();
    format = new TextFormat(null, 30);
    format.align = openfl.text.TextFormatAlign.CENTER;
    addEventListener(Event.ADDED_TO_STAGE, init);
    mode = generateMode;
  }

  function init (e) {
    removeEventListener(Event.ADDED_TO_STAGE, init);

    button = new TextField();
    button.border = true;
    button.selectable = false;
    button.text = buttonText;
    button.setTextFormat(format);
    button.width = button.textWidth;
    button.height = button.textHeight;

    button.x = (stage.stageWidth - button.width) / 2;
    button.y = 30;

    button.addEventListener(MouseEvent.CLICK, onClick);

    addChild(button);
  }


  function onClick (e) {
    if (mode == generateMode || null)
      generatePuzzle();
    else if (mode == revealMode)
      revealAnswer();
  }
  

  function revealAnswer () {
    answerField.visible = true;
    button.text = buttonText;
    mode = generateMode;
  }
  
  function generatePuzzle() {

    var square = randomSquare();

    if (squareField == null) {
      squareField = new TextField();
      squareField.selectable = false;
      addChild(squareField);
      squareField.setTextFormat( format );
      squareField.x = (stage.stageWidth - squareField.width) / 2;
      squareField.y = button.y + button.height + 40;

      answerField = new TextField();
      answerField.selectable = false;
      addChild(answerField);
      answerField.setTextFormat( format );
      answerField.x = (stage.stageWidth - answerField.width) / 2;
      answerField.y = squareField.y + squareField.height + 40;
    }
    squareField.text = square.code;
    answerField.text = square.color;
    answerField.visible = false;

    button.text = "reveal";
    mode = revealMode;
  }

}

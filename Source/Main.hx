package;

import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.events.Event;
import openfl.events.MouseEvent;

typedef Square = {letter:Int,number:Int,code:String, color:String};

class Main extends Sprite
{
  final letters = ['a','b','c','d','e','f','g','h'];
  final numbers = [for (i in 0...8) "" + (i+1)];
  final buttonText = "Click for Chess Square";
  var format:TextFormat;
  var button:TextField;
  var squareField:TextField;
  var answerField:TextField;
  var board: Sprite;

  var revealMode = {};
  var generateMode = {};
  var mode:{};

  
  function randomSquare () {
    var letter = Math.floor(Math.random() * 8);
    var number = Math.floor(Math.random() * 8);
    var color = if ((letter + number) % 2 == 0) "Black" else "White";
    var val =  {letter: letter, number: number, code: letters[letter] + numbers[number], color: color};
    return val;
  }

  function drawBoard (?square:Square) {
    board.graphics.clear();
    var boardSide = Math.min(stage.stageWidth * 0.8, 300.0);
    var squareSide = boardSide / 8.0;
    for (cx in 0 ... 8)
      for (cy in 0...8 ) {
        var color:Int = if ((cx + cy) % 2 == 0) 0xFFFFFF else 0x000000;
        board.graphics.beginFill( color );
        board.graphics.drawRect(cx * squareSide, cy * squareSide, squareSide, squareSide);
        board.graphics.endFill();
      }
    if (square != null)
      {
        board.graphics.lineStyle(5.0, 0xFF0000, 0.9);
        board.graphics.drawRect(squareSide * square.letter,
                                squareSide * (7 - square.number),
                                squareSide, squareSide);
      }
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
    board.visible = true;
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

      board = new Sprite();
      addChild(board);
      board.visible = false;
      drawBoard();
      board.x = (stage.stageWidth - board.width) / 2;
      board.y = answerField.y + 50;
    }
    squareField.text = square.code;
    answerField.text = square.color;
    answerField.visible = false;
    board.visible = false;
    drawBoard( square );

    button.text = "reveal";
    mode = revealMode;
  }

}

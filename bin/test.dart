import 'dart:io';
import 'dart:math';

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
void main() {
    List inputs;
    
    inputs = stdin.readLineSync().split(' ');
    int width = int.parse(inputs[0]); // width of the firewall grid
    int height = int.parse(inputs[1]); // height of the firewall grid
    
    List map = new List.generate(width, (_) => new List.filled(height, '.'));
    
    for (int y = 0; y < height; y++) {
      var row = stdin.readLineSync().split('');
      row.asMap().forEach((x,code)=> map[x][y] = code);
    }
    
    gridLoop(loop(x,y)){
      for(int x = 0; x < width; x += 1){
        for(int y = 0; y < height; y += 1){
          loop(x,y);
        }
      }
    }
    
    // return false to stop;
    cross(x,y, bool callback(x,y)){
      bool arm(List xy){
        var x = xy[0];
        var y = xy[1];
        
        //test for out of bound
        if(x < 0 || x >= width){
          return true;
        }
        if(y < 0 || y >= height){
          return true;
        }
        return !callback(x,y);
      }
      [[x +1, y],[x +2, y],[x +3, y]].firstWhere(arm, orElse:() => true);
      [[x -1, y],[x -2, y],[x -3, y]].firstWhere(arm, orElse:() => true);
      [[x, y +1],[x, y +2],[x, y +3]].firstWhere(arm, orElse:() => true);
      [[x, y -1],[x, y -2],[x, y -3]].firstWhere(arm, orElse:() => true);
    }

    // game loop
    while (true) {
        inputs = stdin.readLineSync().split(' ');
        int rounds = int.parse(inputs[0]); // number of rounds left before the end of the game
        int bombs = int.parse(inputs[1]); // number of bombs left
        
        List grid = new List.generate(width, (_) => new List.filled(height, 0));
        
        //countdown
        gridLoop((x,y){
          var v = map[x][y];
          if(v == '3'){
            map[x][y] = '2';
          }
          if(v == '2'){
            map[x][y] = '1';
          }
          if(v == '1'){
            map[x][y] = '.';
          }
        });
        
        // find tragets
        gridLoop((x,y){
          var s = map[x][y];
          if(s == '@'){
            grid[x][y] = -1;
            cross(x,y, (x,y){
              if(map[x][y] == '#'){
                return false;
              }
              grid[x][y] += 1;
              return true;
            });
          }
        });
        
        //remove invalid locations
        gridLoop((x,y){
          var v = map[x][y];
          if(v == '#'){
            grid[x][y] = -1;
          }
        });
        
        stderr.writeln(map);
        stderr.writeln(grid);
        
        var max = 0;
        var bx = -1;
        var by = -1;
        
        // find good bomb placement
        gridLoop((x,y){
          var v =  grid[x][y];
          if(v > max){
            max = v;
            bx = x;
            by = y;
          }
        });
        
        // place bomb
        if(max != 0 && bombs > 0 && map[bx][by] == '.'){
          print('$bx $by');
          
          //remove all bombs this bomb will hit
          cross(bx,by,(x,y){
            if(map[x][y] == '#'){
              return false;
            }
            if(map[x][y] == '@'){
              map[x][y] = '3';
            }
            return true;
          });
        }else{
          print('WAIT');
        }
        
    }
}

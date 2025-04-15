class Main {
    static function main() {
      var list:Array<Null<Int>> = [
              50, 10, 40, 2, 5, 3, 140, 120, null, null, null, null, null
      ];
      
      list.sort((a, b) -> {
              if (a == null|| b == null)
            return 0;
            return a - b;
      });
      
      for (i in list)
          trace(i);

      Sys.sleep(5);
    }
  }
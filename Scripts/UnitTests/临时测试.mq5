void OnStart() 
  { 
//---  
   int a=0xAE;     // 代码 ? 符合于 the '\xAE' 文字 
   int b=0x24;     // 代码 $ 符合于 the '\x24' 文字 
   int c=0xA9;     // 代码 ? 符合于 to the '\xA9' 文字 
   int d=0x263A;   // 代码 ? 符合于 the '\x263A' 文字 
//--- 显示值 
   Print(a,b,c,d); 
//--- 添加字符到字符串 
   string test=""; 
   StringSetCharacter(test,0,a); 
   Print(test); 
//--- 成串的替换字符 
   StringSetCharacter(test,0,b); 
   Print(test); 
//--- 成串的替换字符 
   StringSetCharacter(test,0,c); 
   Print(test); 
//--- 成串的替换字符 
   StringSetCharacter(test,0,d); 
   Print(test); 
//--- 合适的代码 
   int a1=0x2660; 
   int b1=0x2661; 
   int c1=0x2662; 
   int d1=0x2663; 
//--- 添加黑桃字符 
   StringSetCharacter(test,1,a1); 
   Print(test); 
//--- 添加红心字符 
   StringSetCharacter(test,2,b1); 
   Print(test); 
//--- 添加方片字符 
   StringSetCharacter(test,3,c1); 
   Print(test); 
//--- 添加梅花字符 
   StringSetCharacter(test,4,d1); 
   Print(test); 
//--- 成串的字符文字示例 
   test="Queen\x2660Ace\x2662"; 
   printf("%s",test); 
  }
#include <Controls\Dialog.mqh> 
#include <Controls\Button.mqh> 
#include <Controls\Label.mqh> 
#include <Controls\ComboBox.mqh> 
//--- predefined constants 
#define X_START 0 
#define Y_START 0 
#define X_SIZE 280 
#define Y_SIZE 300 
//+------------------------------------------------------------------+ 
//| Dialog class for working with memory                             | 
//+------------------------------------------------------------------+ 
class CMemoryControl : public CAppDialog 
  { 
private: 
   //--- array size 
   int               m_arr_size; 
   //--- arrays 
   char              m_arr_char[]; 
   int               m_arr_int[]; 
   float             m_arr_float[]; 
   double            m_arr_double[]; 
   long              m_arr_long[]; 
   //--- labels 
   CLabel            m_lbl_memory_physical; 
   CLabel            m_lbl_memory_total; 
   CLabel            m_lbl_memory_available; 
   CLabel            m_lbl_memory_used; 
   CLabel            m_lbl_array_size; 
   CLabel            m_lbl_array_type; 
   CLabel            m_lbl_error; 
   CLabel            m_lbl_change_type; 
   CLabel            m_lbl_add_size; 
   //--- buttons 
   CButton           m_button_add; 
   CButton           m_button_free; 
   //--- combo boxes 
   CComboBox         m_combo_box_step; 
   CComboBox         m_combo_box_type; 
   //--- current value of the array type from the combo box 
   int               m_combo_box_type_value; 
  
public: 
                     CMemoryControl(void); 
                    ~CMemoryControl(void); 
   //--- class object creation method 
   virtual bool      Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2); 
   //--- handler of chart events 
   virtual bool      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam); 
  
protected: 
   //--- create labels 
   bool              CreateLabel(CLabel &lbl,const string name,const int x,const int y,const string str,const int font_size,const int clr); 
   //--- create control elements 
   bool              CreateButton(CButton &button,const string name,const int x,const int y,const string str,const int font_size,const int clr); 
   bool              CreateComboBoxStep(void); 
   bool              CreateComboBoxType(void); 
   //--- event handlers 
   void              OnClickButtonAdd(void); 
   void              OnClickButtonFree(void); 
   void              OnChangeComboBoxType(void); 
   //--- methods for working with the current array 
   void              CurrentArrayFree(void); 
   bool              CurrentArrayAdd(void); 
  }; 
//+------------------------------------------------------------------+ 
//| Free memory of the current array                                 | 
//+------------------------------------------------------------------+ 
void CMemoryControl::CurrentArrayFree(void) 
  { 
//--- reset array size 
   m_arr_size=0; 
//--- free the array 
   if(m_combo_box_type_value==0) 
      ArrayFree(m_arr_char); 
   if(m_combo_box_type_value==1) 
      ArrayFree(m_arr_int); 
   if(m_combo_box_type_value==2) 
      ArrayFree(m_arr_float); 
   if(m_combo_box_type_value==3) 
      ArrayFree(m_arr_double); 
   if(m_combo_box_type_value==4) 
      ArrayFree(m_arr_long); 
  }   
//+------------------------------------------------------------------+ 
//| Attempt to add memory for the current array                      | 
//+------------------------------------------------------------------+ 
bool CMemoryControl::CurrentArrayAdd(void) 
  { 
//--- exit if the size of the used memory exceeds the size of the physical memory 
   if(TerminalInfoInteger(TERMINAL_MEMORY_PHYSICAL)/TerminalInfoInteger(TERMINAL_MEMORY_USED)<2) 
      return(false); 
//--- attempt to allocate memory according to the current type 
   if(m_combo_box_type_value==0 && ArrayResize(m_arr_char,m_arr_size)==-1) 
      return(false); 
   if(m_combo_box_type_value==1 && ArrayResize(m_arr_int,m_arr_size)==-1) 
      return(false); 
   if(m_combo_box_type_value==2 && ArrayResize(m_arr_float,m_arr_size)==-1) 
      return(false); 
   if(m_combo_box_type_value==3 && ArrayResize(m_arr_double,m_arr_size)==-1) 
      return(false); 
   if(m_combo_box_type_value==4 && ArrayResize(m_arr_long,m_arr_size)==-1) 
      return(false); 
//--- memory allocated 
   return(true); 
  }   
//+------------------------------------------------------------------+ 
//| Handling events                                                  | 
//+------------------------------------------------------------------+ 
EVENT_MAP_BEGIN(CMemoryControl) 
ON_EVENT(ON_CLICK,m_button_add,OnClickButtonAdd) 
ON_EVENT(ON_CLICK,m_button_free,OnClickButtonFree) 
ON_EVENT(ON_CHANGE,m_combo_box_type,OnChangeComboBoxType) 
EVENT_MAP_END(CAppDialog) 
//+------------------------------------------------------------------+ 
//| Constructor                                                      | 
//+------------------------------------------------------------------+ 
CMemoryControl::CMemoryControl(void) 
  { 
  } 
//+------------------------------------------------------------------+ 
//| Destructor                                                       | 
//+------------------------------------------------------------------+ 
CMemoryControl::~CMemoryControl(void) 
  { 
  } 
//+------------------------------------------------------------------+ 
//| Class object creation method                                     | 
//+------------------------------------------------------------------+ 
bool CMemoryControl::Create(const long chart,const string name,const int subwin, 
                            const int x1,const int y1,const int x2,const int y2) 
  { 
//--- create base class object 
   if(!CAppDialog::Create(chart,name,subwin,x1,y1,x2,y2)) 
      return(false); 
//--- prepare strings for labels 
   string str_physical="Memory physical = "+(string)TerminalInfoInteger(TERMINAL_MEMORY_PHYSICAL)+" Mb"; 
   string str_total="Memory total = "+(string)TerminalInfoInteger(TERMINAL_MEMORY_TOTAL)+" Mb"; 
   string str_available="Memory available = "+(string)TerminalInfoInteger(TERMINAL_MEMORY_AVAILABLE)+" Mb"; 
   string str_used="Memory used = "+(string)TerminalInfoInteger(TERMINAL_MEMORY_USED)+" Mb"; 
//--- create labels 
   if(!CreateLabel(m_lbl_memory_physical,"physical_label",X_START+10,Y_START+5,str_physical,12,clrBlack)) 
      return(false); 
   if(!CreateLabel(m_lbl_memory_total,"total_label",X_START+10,Y_START+30,str_total,12,clrBlack)) 
      return(false); 
   if(!CreateLabel(m_lbl_memory_available,"available_label",X_START+10,Y_START+55,str_available,12,clrBlack)) 
      return(false); 
   if(!CreateLabel(m_lbl_memory_used,"used_label",X_START+10,Y_START+80,str_used,12,clrBlack)) 
      return(false); 
   if(!CreateLabel(m_lbl_array_type,"type_label",X_START+10,Y_START+105,"Array type = double",12,clrBlack)) 
      return(false); 
   if(!CreateLabel(m_lbl_array_size,"size_label",X_START+10,Y_START+130,"Array size = 0",12,clrBlack)) 
      return(false); 
   if(!CreateLabel(m_lbl_error,"error_label",X_START+10,Y_START+155,"",12,clrRed)) 
      return(false); 
   if(!CreateLabel(m_lbl_change_type,"change_type_label",X_START+10,Y_START+185,"Change type",10,clrBlack)) 
      return(false); 
   if(!CreateLabel(m_lbl_add_size,"add_size_label",X_START+10,Y_START+210,"Add to array",10,clrBlack)) 
      return(false); 
//--- create control elements 
   if(!CreateButton(m_button_add,"add_button",X_START+15,Y_START+245,"Add",12,clrBlue)) 
      return(false); 
   if(!CreateButton(m_button_free,"free_button",X_START+75,Y_START+245,"Free",12,clrBlue)) 
      return(false); 
   if(!CreateComboBoxType()) 
      return(false); 
   if(!CreateComboBoxStep()) 
      return(false); 
//--- initialize the variable 
   m_arr_size=0; 
//--- successful execution 
   return(true); 
  } 
//+------------------------------------------------------------------+ 
//| Create the button                                                | 
//+------------------------------------------------------------------+ 
bool CMemoryControl::CreateButton(CButton &button,const string name,const int x, 
                                  const int y,const string str,const int font_size, 
                                  const int clr) 
  { 
//--- create the button 
   if(!button.Create(m_chart_id,name,m_subwin,x,y,x+50,y+20)) 
      return(false); 
//--- text 
   if(!button.Text(str)) 
      return(false); 
//--- font size 
   if(!button.FontSize(font_size)) 
      return(false); 
//--- label color 
   if(!button.Color(clr)) 
      return(false); 
//--- add the button to the control elements 
   if(!Add(button)) 
      return(false); 
//--- successful execution 
   return(true); 
  } 
//+------------------------------------------------------------------+ 
//| Create a combo box for the array size                            | 
//+------------------------------------------------------------------+ 
bool CMemoryControl::CreateComboBoxStep(void) 
  { 
//--- create the combo box 
   if(!m_combo_box_step.Create(m_chart_id,"step_combobox",m_subwin,X_START+100,Y_START+185,X_START+200,Y_START+205)) 
      return(false); 
//--- add elements to the combo box 
   if(!m_combo_box_step.ItemAdd("100 000",100000)) 
      return(false); 
   if(!m_combo_box_step.ItemAdd("1 000 000",1000000)) 
      return(false); 
   if(!m_combo_box_step.ItemAdd("10 000 000",10000000)) 
      return(false); 
   if(!m_combo_box_step.ItemAdd("100 000 000",100000000)) 
      return(false); 
//--- set the current combo box element 
   if(!m_combo_box_step.SelectByValue(1000000)) 
      return(false); 
//--- add the combo box to control elements 
   if(!Add(m_combo_box_step)) 
      return(false); 
//--- successful execution 
   return(true); 
  } 
//+------------------------------------------------------------------+ 
//| Create a combo box for the array type                            | 
//+------------------------------------------------------------------+ 
bool CMemoryControl::CreateComboBoxType(void) 
  { 
//--- create the combo box 
   if(!m_combo_box_type.Create(m_chart_id,"type_combobox",m_subwin,X_START+100,Y_START+210,X_START+200,Y_START+230)) 
      return(false); 
//--- add elements to the combo box 
   if(!m_combo_box_type.ItemAdd("char",0)) 
      return(false); 
   if(!m_combo_box_type.ItemAdd("int",1)) 
      return(false); 
   if(!m_combo_box_type.ItemAdd("float",2)) 
      return(false); 
   if(!m_combo_box_type.ItemAdd("double",3)) 
      return(false); 
   if(!m_combo_box_type.ItemAdd("long",4)) 
      return(false); 
//--- set the current combo box element 
   if(!m_combo_box_type.SelectByValue(3)) 
      return(false); 
//--- store the current combo box element 
   m_combo_box_type_value=3; 
//--- add the combo box to control elements 
   if(!Add(m_combo_box_type)) 
      return(false); 
//--- successful execution 
   return(true); 
  } 
//+------------------------------------------------------------------+ 
//| Create a label                                                   | 
//+------------------------------------------------------------------+ 
bool CMemoryControl::CreateLabel(CLabel &lbl,const string name,const int x, 
                                 const int y,const string str,const int font_size, 
                                 const int clr) 
  { 
//--- create a label 
   if(!lbl.Create(m_chart_id,name,m_subwin,x,y,0,0)) 
      return(false); 
//--- text 
   if(!lbl.Text(str)) 
      return(false); 
//--- font size 
   if(!lbl.FontSize(font_size)) 
      return(false); 
//--- color 
   if(!lbl.Color(clr)) 
      return(false); 
//--- add the label to control elements 
   if(!Add(lbl)) 
      return(false); 
//--- succeed 
   return(true); 
  } 
//+------------------------------------------------------------------+ 
//| Handler of clicking "Add" button event                           | 
//+------------------------------------------------------------------+ 
void CMemoryControl::OnClickButtonAdd(void) 
  { 
//--- increase the array size 
   m_arr_size+=(int)m_combo_box_step.Value(); 
//--- attempt to allocate memory for the current array 
   if(CurrentArrayAdd()) 
     { 
      //--- memory allocated, display the current status on the screen 
      m_lbl_memory_available.Text("Memory available = "+(string)TerminalInfoInteger(TERMINAL_MEMORY_AVAILABLE)+" Mb"); 
      m_lbl_memory_used.Text("Memory used = "+(string)TerminalInfoInteger(TERMINAL_MEMORY_USED)+" Mb"); 
      m_lbl_array_size.Text("Array size = "+IntegerToString(m_arr_size)); 
      m_lbl_error.Text(""); 
     } 
   else 
     { 
      //--- failed to allocate memory, display the error message 
      m_lbl_error.Text("Array is too large, error!"); 
      //--- return the previous array size 
      m_arr_size-=(int)m_combo_box_step.Value(); 
     } 
  } 
//+------------------------------------------------------------------+ 
//| Handler of clicking "Free" button event                          | 
//+------------------------------------------------------------------+ 
void CMemoryControl::OnClickButtonFree(void) 
  { 
//--- free the memory of the current array 
   CurrentArrayFree(); 
//--- display the current status on the screen 
   m_lbl_memory_available.Text("Memory available = "+(string)TerminalInfoInteger(TERMINAL_MEMORY_AVAILABLE)+" Mb"); 
   m_lbl_memory_used.Text("Memory used = "+(string)TerminalInfoInteger(TERMINAL_MEMORY_USED)+" Mb"); 
   m_lbl_array_size.Text("Array size = 0"); 
   m_lbl_error.Text(""); 
  } 
//+------------------------------------------------------------------+ 
//| Handler of the combo box change event                            | 
//+------------------------------------------------------------------+ 
void CMemoryControl::OnChangeComboBoxType(void) 
  { 
//--- check if the array's type has changed 
   if(m_combo_box_type.Value()!=m_combo_box_type_value) 
     { 
      //--- free the memory of the current array 
      OnClickButtonFree(); 
      //--- work with another array type 
      m_combo_box_type_value=(int)m_combo_box_type.Value(); 
      //--- display the new array type on the screen 
      if(m_combo_box_type_value==0) 
         m_lbl_array_type.Text("Array type = char"); 
      if(m_combo_box_type_value==1) 
         m_lbl_array_type.Text("Array type = int"); 
      if(m_combo_box_type_value==2) 
         m_lbl_array_type.Text("Array type = float"); 
      if(m_combo_box_type_value==3) 
         m_lbl_array_type.Text("Array type = double"); 
      if(m_combo_box_type_value==4) 
         m_lbl_array_type.Text("Array type = long"); 
     } 
  } 
//--- CMemoryControl class object 
CMemoryControl ExtDialog; 
//+------------------------------------------------------------------+ 
//| Expert initialization function                                   | 
//+------------------------------------------------------------------+ 
int OnInit() 
  { 
//--- create the dialog 
   if(!ExtDialog.Create(0,"MemoryControl",0,X_START,Y_START,X_SIZE,Y_SIZE)) 
      return(INIT_FAILED); 
//--- launch 
   ExtDialog.Run(); 
//--- 
   return(INIT_SUCCEEDED); 
  } 
//+------------------------------------------------------------------+ 
//| Expert deinitialization function                                 | 
//+------------------------------------------------------------------+ 
void OnDeinit(const int reason) 
  { 
//--- 
   ExtDialog.Destroy(reason); 
  } 
//+------------------------------------------------------------------+ 
//| Expert chart event function                                      | 
//+------------------------------------------------------------------+ 
void OnChartEvent(const int id, 
                  const long &lparam, 
                  const double &dparam, 
                  const string &sparam) 
  { 
   ExtDialog.ChartEvent(id,lparam,dparam,sparam); 
  }
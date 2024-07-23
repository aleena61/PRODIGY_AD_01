import 'package:calculator/button_values.dart';
import 'package:flutter/material.dart';

class Calculatorscreen extends StatefulWidget {
  const Calculatorscreen({super.key});

  @override
  State<Calculatorscreen> createState() => _CalculatorscreenState();
}

class _CalculatorscreenState extends State<Calculatorscreen> {
  String num1="";
  String oper="";
  String num2="";
  @override
  Widget build(BuildContext context) {
    final screenSize=MediaQuery.of(context).size;
    return Scaffold(
      body:SafeArea(
        bottom: false,
       child: Column(
        children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child:  Text(
                    "$num1$oper$num2".isEmpty
                    ?"0"
                    :"$num1$oper$num2",
                  style:const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),
            Wrap(
              children: Btn.buttonValues
              .map(
                (value)=>
                SizedBox(
                  width:value==Btn.n0?
                  screenSize.width/2
                  :screenSize.width/4 ,
                  height: screenSize.width/4,
                  child: buildButton(value)),
                )
                .toList()
            ) 
        ],
        ),
      )
    );
  }

    Widget buildButton(value){
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Material(
          color:getBtnColor(value),
          clipBehavior: Clip.hardEdge,
          shape:OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide:const BorderSide(color: Colors.white24),
            ) ,
          
          child: InkWell(
            onTap: ()=>onBtnTap(value),
            child: Center(
              child: Text(value,style: 
              const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color:  Colors.white,
              ),)),
          ),
        ),
      );
    }

    void onBtnTap(String value){
      if(value==Btn.del){
        delete();
        return;
      }
      if(value==Btn.clr){
        clearAll();
        return;
      }
      if(value==Btn.per){
        convertToP();
        return;
      }
      if(value==Btn.calculate){
        calculate();
        return;
      }
      appendValue(value);
    }

    void calculate(){
      if(num1.isEmpty) return;
      if(oper.isEmpty) return;
      if(num2.isEmpty) return;

      final double numb1=double.parse(num1);
      final double numb2=double.parse(num2);
      var result=0.0;
      switch(oper){
        case Btn.add:
        result=numb1+numb2;
        break;
        case Btn.subtract:
        result=numb1-numb2;
        break;
        case Btn.multiply:
        result=numb1*numb2;
        break;
        case Btn.divide:
        result=numb1/numb2;
        break;
        default:
      }
      setState(() {
        num1=result.toStringAsPrecision(5);
        if(num1.endsWith('.0')){
          num1=num1.substring(0,num1.length-2);
        }
        oper="";
        num2="";
      });
    }

    void convertToP(){
      if(num1.isNotEmpty&&oper.isNotEmpty&&num2.isNotEmpty){
       calculate();
      }
      if(oper.isNotEmpty){
        return;
      }
      final number=double.parse(num1);
      setState(() {
        num1="${(number/100)}";
        oper="";
        num2="";
      });
    }

    void clearAll(){
      setState(() {
        num1="";
        oper="";
        num2='';
      });
    }

    void delete(){
      if(num2.isNotEmpty){
        num2=num2.substring(0,num2.length-1);
      }
      else if(oper.isNotEmpty){
        oper="";
      }
      else if(num1.isNotEmpty){
        num1=num1.substring(0,num1.length-1);
      }
      setState(() {});
    }

    void appendValue(String value){
      if(value!=Btn.dot&&int.tryParse(value)==null){
        if(oper.isNotEmpty&&num2.isNotEmpty){
          calculate();
        }
        oper=value;
        }else if(num1.isEmpty||oper.isEmpty){
          if(value==Btn.dot&&num1.contains(Btn.dot)) return;
          if(value==Btn.dot&&(num1.isEmpty||num1==Btn.n0)){
            value="0.";
          }
          num1+=value;
        }
        else if(num2.isEmpty||oper.isNotEmpty){
          if(value==Btn.dot&&num2.contains(Btn.dot)) return;
          if(value==Btn.dot&&(num2.isEmpty||num2==Btn.n0)){
            value="0.";
          }
          num2+=value;
        }
      
      setState(() {}
      );
    }

    

    Color getBtnColor(value){
      return [Btn.del,Btn.clr].contains(value)?const Color.fromRGBO(200, 155, 123, 1):
          [Btn.per,Btn.add,Btn.multiply,Btn.subtract,Btn.calculate,Btn.divide].contains(value)?const Color.fromRGBO(171, 196, 171, 1)
          :const Color.fromRGBO(109, 76, 61, 1);
    }
  }

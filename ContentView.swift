//
//  ContentView.swift
//  calculator
//
//  Created by admin on 2021/7/31.
//

import SwiftUI
import CoreData
struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var data:datauser
    var body: some View {
            
        VStack{
            Spacer()
            VStack(alignment:.trailing){
                Text("\(data.answer)")
                    .foregroundColor(.white)
                    .font(.custom("", size:data.answer.count > 20 ?  CGFloat((50 - Double(data.answer.count)/1.5)):50))
                    .lineLimit(1)
            }.frame(width:UIScreen.main.bounds.width,alignment: .trailing)
                
            
            HStack{
                button(color: "lightGray", num: "AC")
                addingMinus().environmentObject(data)
                button(color: "lightGray", num: "%")
                button(color: "yellow", num: "÷")
            }
            HStack{
                button(color: "darkGray", num: "7")
                button(color: "darkGray", num: "8")
                button(color: "darkGray", num: "9")
                button(color: "yellow", num: "×")
            }
            HStack{
                button(color: "darkGray", num: "4")
                button(color: "darkGray", num: "5")
                button(color: "darkGray", num: "6")
                button(color: "yellow", num: "−")
            }
            HStack{
                button(color: "darkGray", num: "1")
                button(color: "darkGray", num: "2")
                button(color: "darkGray", num: "3")
                button(color: "yellow", num: "+")
            }
            HStack{
                button(color: "darkGray", num: "0")
                button(color: "darkGray", num: ".")
                button(color: "yellow", num: "=")
            }.padding(.bottom,40)
            
            
            
            
        }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color.black)
        .ignoresSafeArea()
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
struct button:View{
    @State var color = ""
    @State var num = ""
    @EnvironmentObject var data:datauser
    var body: some View{
        Button(action: {
            
            
            if let integerInput:Int = Int(num) {
                if data.operation.isEmpty {
                    data.firstNum.append(num)
                    data.answer = data.firstNum
                }else {
                    data.SecondNum.append(num)
                    data.answer = data.SecondNum
                }
                
            }else if num=="."{
                data.firstNum.append(num)
                data.answer = data.firstNum
            }
            else if num == "="{
                var firstNum = 0.0  , secondNum = 0.0
                firstNum = Double(data.firstNum) ?? 0
                secondNum = Double(data.SecondNum) ?? 0
                data.answer = String(getResult(operating: data.operation, num1: firstNum, num2: secondNum))
                data.firstNum = data.answer
                data.SecondNum = ""
                data.operation = ""

                
                
            }else {
                data.operation =  num
                data.answer = data.operation
                data.operation = getStr(num: num)
            }
            if num=="AC" {
                data.answer = ""
                data.operation = ""
                data.firstNum = ""
                data.SecondNum = ""
            }
            if num=="%"{
                data.answer = String(Double(data.firstNum)! /  100)
            }
            
        }, label: {
            ZStack{
                Rectangle()
                    .frame(width:num=="0" ? 185: 90, height: 90)
                    .cornerRadius(50)
                    .foregroundColor(Color(color))
                Text("\(num)")
                    .foregroundColor(Color(color=="lightGray" ? "black":"white"))
                    .font(.title)
                    .bold()
            }
        })
    }
    func getStr(num:String)->String{
        switch num {
        case "÷":
            return "divide"
        case "×":
            return "multi"
        case "+":
            return "add"
        case "−":
            return "minus"
        case ".":
            return "Dot"
        default:
            return "error"
        }
    }
    func getResult(operating:String,num1:Double,num2:Double)->Double{
        switch operating {
        case "add":
            return additon(num1: num1, num2: num2)
        case "minus":
            return subtarction(num1: num1, num2: num2)
        case "multi":
            return multiplication(num1: num1, num2: num2)
        case "divide":
            return division(num1: num1, num2: num2)
        default:
            return 0
        }
    }
    
    func additon(num1:Double,num2:Double)->Double{
        return num1+num2
    }
    func subtarction(num1:Double,num2:Double)->Double{
        return num1-num2
    }
    func multiplication(num1:Double,num2:Double)->Double{
        return num1*num2
    }
    func division(num1:Double,num2:Double)->Double{
        return num1/num2
    }

    
}
struct addingMinus:View{
    @EnvironmentObject var data:datauser
    var body: some View{
        Button(action: {
            data.answer = "-"+data.answer
            if data.SecondNum.isEmpty {
                data.firstNum =  "-"+data.firstNum
            }else {
                data.SecondNum =  "-"+data.SecondNum
            }
           
        }, label: {
            ZStack{
                Rectangle()
                    .frame(width: 90, height: 90)
                    .cornerRadius(50)
                    .foregroundColor(Color("lightGray"))
                Text("/").foregroundColor(.black).font(.title)
                Text("+").offset(x: -8, y: -4).foregroundColor(.black)
                Text("-").offset(x: 8, y: 4).foregroundColor(.black)
            }
        })
    }
}

--本文件用于记录Theorem_Proving_In_Lean4中Type Theory部分的内容

/-下面是lean文件配置-/
import Lean.Elab
set_option linter.unusedVariables false --阻止lean对未使用的变量报错
set_option diagnostics true

/-Simple Type Theory-/
--需要记住三个常用的关键字——def（用于定义）check（用于检查类型）eval（用于评估）
--下面是一个简单的例子
def m : Nat := 1       -- m is a natural number
def n : Nat := 0
def b1 : Bool := true  -- b1 is a Boolean
def b2 : Bool := false



-- TODO 补全👆的内容，当然前提是自己先搞明白😖
#check (fun x : Nat => x) 1     -- Nat
#check (fun x : Nat => true) 1  -- Bool

def f (n : Nat) : String := toString n
def g (s : String) : Bool := s.length > 0

#check (fun (α β γ : Type) (u : β → γ) (v : α → β) (x : α) => u (v x)) Nat String Bool g f 0

/-def(definitions)使用方法-/
/-def的一般形式：
def foo : α := bar
其中
  α 是从bar表达式返回值的类型，有时可以不明确指出（但最好还是标注上）
  bar可以是任何合理的表达式，可以是lamda函数也可以是单独一个值-/

--使用def可以定义一些简单的函数，这里定义了一个Nat → Nat的函数double，接受一个x : Nat并且返回x + x : Nat
--方案一：直接通过类型来定义
def double_1 (x : Nat) : Nat := x + x
#eval double_1 3
--方案二：double可以看作一种命名的lamda
def double_2 :Nat → Nat :=
  fun x => x + x
#eval double_2 4
--方案2.5：可以省略类型(当然这种情况是在lean有足够信息进行类型推断的时候)
def double_2_5 :=
  λ x : Nat => x + x
#eval double_2_5 5

--def也可以定义传入多个参数的表达式,传入的参数放一起也可以分开
def add_1 (x y : Nat) : Nat := x + y
def add_2 (x : Nat) (y : Nat) : Nat := x + y
#eval add_1 1 2
#eval add_2 1 2
#eval add_1 (double_1 3) (9 + 1)

--结合以上两点就可以实现一些非常有趣的功能，比如最大值函数
def greater (x y : Nat) :=
  if x > y then x else y
#eval greater 4 6

--当然也可以在定义时引入其他函数做一些更fancy的操作
def doTwice (f : Nat -> Nat)(x : Nat) : Nat := f (f x)
#eval doTwice double_1 2

--还可以更抽象一点，传入任意类型的函数组合（当然两个函数的输入输出需要能串在一起），不妨用一个平方函数来测试一下我们的成果
def compose (α β γ : Type) (g : β   -> γ ) (f : α  -> β)(x : α) : γ := g (f x)
def square (x : Nat) : Nat := x * x
#eval compose Nat Nat Nat double_1 square 3

/-本地定义:Local Definition
--lean支持使用let关键字来进行替换操作，一般形式为
let a := t1 ; t2
这个表达式是什么意思呢，其实就是将 t2 中出现的所有a都变成 t1，下面给出一个非常简单的例子
-/
def twice_double (x : Nat) : Nat := let y := x + x ; y * y -- it means (x + x) * (x + x)
#eval twice_double 2 --16

--非常让人迷惑的一个点是let 和 fun、lamda的区别: let a := t1 ; t2 & (fun α => t2) t1 一样吗？
--举个例子就可以看出，let实际上做的是类似字符替代的工作，就是把 t1 替换成了 α 而已
--而fun则要求表达式 fun α => t2 的成立与否与α的值无关才可以，实例中只有在α为Nat时才可以，故替换不可行
def foo := let α := Nat ;fun x : α => x + 2
--def bar := (fun a => fun x : a => x + 2) Nat     this one will fail


/-
在开始下一部分之间，先介绍一下Sections和namespace的概念（相信用过C++的同学应该不会太陌生）
他们可以避免定义函数的名称冲突问题，有了这两个东西，我们可以将自己的定义分组
-/

/-Variables：变量的声明，方便定义的进行，但是如果不使用Sections进行范围控制，声明的变量将会作用于整个文件，给出一个示范-/
section test
  --范围内的variable会在整个section内有效，使用end后结束作用
  variable (α β γ : Type)--可以声明为Type
  variable (g : β -> γ )(f :α -> β )(h : α -> α )--当然也可以做任意类型
  variable (x : α)

  def compose_test := g (f x)
  def doTwice_test := h (h x)
  def doThrice := h (h (h x))
end test

/-相比于section内的声明脱离section外不可用，namespace提供了更方便的作用方式-/
namespace test2
  def a : Nat := 5
  def f (x : Nat) : Nat := x + 7

  def fa : Nat := f a
  def ffa : Nat := f (f a)

  #check a
  #check f
  #check fa
  #check ffa
  #check test2.fa
end test2
--在终止test2后，可以使用前缀来使用内部的函数
#check test2.a
#check test2.f
#check test2.fa
#check test2.ffa

open test2
--在使用open后，test2的函数可以直接使用而不需要前缀
#check a
#check f
#check fa
#check test2.fa

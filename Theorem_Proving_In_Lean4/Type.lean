--本文件用于记录Theorem_Proving_In_Lean4中Type Theory部分的内容

/-下面是lean文件配置-/
set_option linter.unusedVariables false --阻止lean对未使用的变量报错

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

/-- Inductive definition of a type. Definition 1.2 --/
inductive WFF : Type
  -- Base case
  | p_atm : String → WFF
  -- Induction steps
  | p_not : WFF → WFF
  | p_and : WFF → WFF → WFF
  | p_or  : WFF → WFF → WFF
  | p_imp : WFF → WFF → WFF
  | p_iff : WFF → WFF → WFF

open WFF

/-- Inductive definition of a function. Definition 1.3 --/
def WFF_to_String : WFF → String
  -- Base case
  | p_atm s   => s
  -- Induction steps
  | p_not φ   => "(¬" ++ WFF_to_String φ ++  ")"
  | p_and φ ψ => "(" ++ WFF_to_String φ ++ " ∧ " ++ WFF_to_String ψ ++ ")"
  | p_or  φ ψ => "(" ++ WFF_to_String φ ++ " ∨ " ++ WFF_to_String ψ ++ ")"
  | p_imp φ ψ => "(" ++ WFF_to_String φ ++ " → " ++ WFF_to_String ψ ++ ")"
  | p_iff φ ψ => "(" ++ WFF_to_String φ ++ " ↔ " ++ WFF_to_String ψ ++ ")"

/-- Utility function for fancy outputs --/
instance : ToString WFF where
  toString := WFF_to_String

def A₁ : WFF := p_atm "A₁"
def A₂ : WFF := p_atm "A₂"
def A₃ : WFF := p_atm "A₃"
def A₄ : WFF := p_atm "A₄"
def A₅ : WFF := p_atm "A₅"
def A₆ : WFF := p_atm "A₆"
def A₇ : WFF := p_atm "A₇"
def A₈ : WFF := p_atm "A₈"
def A₉ : WFF := p_atm "A₉"
def A₁₀ : WFF := p_atm "A₁₀"
def complex_WFF : WFF :=
  p_imp (p_and A₁ (p_not A₂)) A₃

#eval WFF_to_String complex_WFF

/-- Definition 1.4 --/
def construct_seq : WFF → List WFF
  -- Base case
  | p_atm s   => [p_atm s]
  -- Induction steps
  | p_not φ   => (construct_seq φ) ++ [p_not φ]
  | p_and φ ψ => (construct_seq φ) ++ (construct_seq ψ) ++ [p_and φ ψ]
  | p_or  φ ψ => (construct_seq φ) ++ (construct_seq ψ) ++ [p_or φ ψ]
  | p_imp φ ψ => (construct_seq φ) ++ (construct_seq ψ) ++ [p_imp φ ψ]
  | p_iff φ ψ => (construct_seq φ) ++ (construct_seq ψ) ++ [p_iff φ ψ]

#eval construct_seq complex_WFF

/-- Example --/
def super_complex_WFF : WFF :=
  p_imp (p_and A₁ A₁₀) (p_or (p_not A₃) (p_iff A₈ A₃))

#eval super_complex_WFF
#eval construct_seq super_complex_WFF

/-- Functions for formalizing Theorem 1.8 --/
def WFF_num_left_brackets : WFF → Nat
  -- base case
  | p_atm _   => 0
  -- induction step
  | p_not φ   => WFF_num_left_brackets φ + 1
  | p_and φ ψ => WFF_num_left_brackets φ + WFF_num_left_brackets ψ + 1
  | p_or  φ ψ => WFF_num_left_brackets φ + WFF_num_left_brackets ψ + 1
  | p_imp φ ψ => WFF_num_left_brackets φ + WFF_num_left_brackets ψ + 1
  | p_iff φ ψ => WFF_num_left_brackets φ + WFF_num_left_brackets ψ + 1

def WFF_num_right_brackets : WFF → Nat
  -- base case
  | p_atm _   => 0
  -- induction step
  | p_not φ   => WFF_num_right_brackets φ + 1
  | p_and φ ψ => WFF_num_right_brackets φ + WFF_num_right_brackets ψ + 1
  | p_or  φ ψ => WFF_num_right_brackets φ + WFF_num_right_brackets ψ + 1
  | p_imp φ ψ => WFF_num_right_brackets φ + WFF_num_right_brackets ψ + 1
  | p_iff φ ψ => WFF_num_right_brackets φ + WFF_num_right_brackets ψ + 1

#eval super_complex_WFF
#eval WFF_num_right_brackets super_complex_WFF

/-- Theorem 1.8a. TODO: please finish the proof by yourself --/
theorem WFF_balance_of_brackets : ∀ f : WFF, WFF_num_left_brackets f = WFF_num_right_brackets f := by
  intro f
  induction f
  case p_atm => rfl
  case p_not f' IH_not =>
    unfold WFF_num_left_brackets
    unfold WFF_num_right_brackets
    rewrite [IH_not]
    rfl
  case p_and f' g' IH_and_1 IH_and_2 =>
    unfold WFF_num_left_brackets
    unfold WFF_num_right_brackets
    rewrite [IH_and_1, IH_and_2]
    rfl
  case p_or  =>
    sorry
  case p_imp =>
    sorry
  case p_iff =>
    sorry

set_option linter.unusedVariables false

#check (fun x : Nat => x) 1     -- Nat
#check (fun x : Nat => true) 1  -- Bool

def f (n : Nat) : String := toString n
def g (s : String) : Bool := s.length > 0

#check (fun (α β γ : Type) (u : β → γ) (v : α → β) (x : α) => u (v x)) Nat String Bool g f 0

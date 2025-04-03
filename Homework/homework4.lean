import Mathlib.Logic.Basic

-- Declare Hilbert-style axioms with implicit arguments.
axiom A1 (α β : Prop) : (α ∧ β) → α
axiom A2 (α β : Prop) : (α ∧ β) → β
axiom A3 (α β : Prop) : α → (β → (α ∧ β))
axiom A4 (α β : Prop) : α → (α ∨ β)
axiom A5 (α β : Prop) : β → (α ∨ β)
axiom A6 (α β γ : Prop) : (α → γ) → ((β → γ) → ((α ∨ β) → γ))
axiom A7 (α β : Prop) : α → (β → α)
axiom A8 (α β γ : Prop) : (α → (β → γ)) → ((α → β) → (α → γ))
axiom A9 (α β : Prop) : (α → β) → ((α → ¬β) → ¬α)
axiom A10 (α β : Prop) : ¬α → (α → β)
axiom A11 (α : Prop) : α → True
axiom A12 (α : Prop) : False → α
axiom A13 (α : Prop) : (α → False) → ¬α
-- prove axiom A14 as homework

-- Note the difference of Boolean and Proposition types
#check Bool.true
#check true
#check True

-- Example
theorem imp_vee (δ φ : Prop) : (¬δ ∨ φ) → (δ → φ) := by
  let h1 : ¬δ → (δ → φ) := A10 δ φ
  let h2 :  φ → (δ → φ) := A7 φ δ
  let h3 : (¬δ → (δ → φ)) → (φ → (δ → φ)) → ((¬δ ∨ φ) → (δ → φ)) := A6 (¬δ) φ (δ → φ)
  exact h3 h1 h2

-- Example 2: now we prove φ → φ
theorem id_phi (φ : Prop) : φ → φ := by
  -- Instantiate H7 with α := φ and β := φ.
  let h1 : φ → (φ → φ) := A7 φ φ
  -- Instantiate H7 with α := φ and β := (φ → φ).
  let h2 : φ → ((φ → φ) → φ) := A7 φ (φ → φ)
  -- Instantiate H8 with α := φ, β := (φ → φ), and γ := φ.
  let h3 : (φ → ((φ → φ) → φ)) → ((φ → (φ → φ)) → (φ → φ)) :=
    A8 φ (φ → φ) φ
  -- Apply h3 to h2 to obtain a function of type φ → (φ → φ) → (φ → φ)
  have h4 : (φ → (φ → φ)) → (φ → φ) := h3 h2 -- make sure the order is correct
  -- Finally, apply h4 to h1 to yield the desired proof.
  exact h4 h1

-- Example 3: syllogism, sentential ver.
theorem prop_syl (α β γ : Prop) (h1 : α → β) (h2 : β → γ) : α → γ := by
  let h3 : (β → γ) → (α → (β → γ)) := A7 (β → γ) α
  have h4 : (α → (β → γ)) := h3 h2
  let h5 : (α → (β → γ)) → ((α → β) → (α → γ)) := A8 α β γ
  have h6 : (α → β) → (α → γ) := h5 h4
  exact h6 h1

-- Example 4: use deduction theorem to prove identity theorem
theorem id_phi_2 (φ : Prop) : φ → φ := by
  intro h1
  exact h1

-- Example 5: use deduction theorem to prove syllogism
theorem prop_syl_2 (α β γ : Prop) (h1 : α → β) (h2 : β → γ) : α → γ := by
  intro h3 -- apply deduction theorem
  have h4 : β := h1 h3
  have h5 : γ := h2 h4
  exact h5

/-- Homework 5:
    - Please be advised that this homework requires *syntactic proofs* only. You must use only the previously provided axioms and theorems. Aim to construct your own theory and axiomatic framework.
    - You may use deduction theorem to simplify your proof.
    - Let us faithfully follow Hilbert's teachings, DO NOT use shortcut tactics like "simp" or "simp_all", otherwise you won't get any credit in this homework.
--/

-- Contraposition
theorem contr_pos (α β : Prop) : (α → β) → (¬β → ¬α) := by
  sorry

-- Triple negations
theorem tri_neg (φ : Prop) : ¬¬¬φ → ¬φ := by
  sorry

-- Axiom 14
theorem A14 (α : Prop) : (¬¬α → α) :=
  sorry

theorem prop_1 (φ ψ γ : Prop) : (γ → ψ) → ((φ → γ) → (φ → ψ)) := by
  sorry

theorem prop_2 (φ γ : Prop) : φ → ((φ → γ) → γ) := by
  sorry

theorem prop_3 (φ γ ψ δ : Prop) : ((((φ ∧ γ) → ψ) → δ) → ((φ → ψ) → δ)) := by
  sorry

theorem prop_4 (φ γ : Prop) (h1 : φ → γ) (h2 : φ → ¬γ) : ¬φ := by
  sorry

theorem prop_5 (φ ψ γ : Prop) (h1 : γ → ψ) (h2 : γ → (ψ → φ)) : γ → φ := by
  sorry

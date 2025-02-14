{-# OPTIONS --without-K --exact-split --safe #-}

open import MLTT.Spartan

open import UF.FunExt 
open import Notation.Order
open import Naturals.Order
open import TypeTopology.DiscreteAndSeparated
open import CoNaturals.GenericConvergentSequence
 hiding (max)
 renaming (ℕ-to-ℕ∞ to _↑)

open import TWA.Thesis.Chapter2.Sequences
open import TWA.Thesis.Chapter2.Vectors 
open import TWA.Thesis.Chapter5.SignedDigit

module TWA.Thesis.Chapter6.SignedDigitContinuity (fe : FunExt) where

open import TWA.Thesis.Chapter3.ClosenessSpaces fe
open import TWA.Thesis.Chapter3.ClosenessSpaces-Examples fe
open import TWA.Thesis.Chapter3.SearchableTypes fe
open import TWA.Thesis.Chapter6.SequenceContinuity fe

div2-ucontinuous' : seq-f-ucontinuous¹ div2
div2-ucontinuous' zero = 0 , λ α β _ k ()
div2-ucontinuous' (succ ε) = succ (succ ε) , γ ε where
  γ : (ε : ℕ) → (α β : ℕ → 𝟝) → (α ∼ⁿ β) (succ (succ ε))
    →  (div2 α ∼ⁿ div2 β) (succ ε)
  γ ε α β α∼ⁿβ 0 ⋆ = ap (λ - → pr₁ (div2-aux - (α 1))) (α∼ⁿβ 0 ⋆)
                   ∙ ap (λ - → pr₁ (div2-aux (β 0) -)) (α∼ⁿβ 1 ⋆)
  γ (succ ε) α β α∼ⁿβ (succ k) = γ ε α' β' α∼ⁿβ' k
   where
    α' = pr₂ (div2-aux (α 0) (α 1)) ∶∶ (tail (tail α))
    β' = pr₂ (div2-aux (β 0) (β 1)) ∶∶ (tail (tail β))
    α∼ⁿβ' : (α' ∼ⁿ β') (succ (succ ε))
    α∼ⁿβ' 0 ⋆ = ap (λ - → pr₂ (div2-aux - (α 1))) (α∼ⁿβ 0 ⋆)
             ∙ ap (λ - → pr₂ (div2-aux (β 0) -)) (α∼ⁿβ 1 ⋆)
    α∼ⁿβ' (succ j) = α∼ⁿβ (succ (succ j))

map-ucontinuous' : {X : 𝓤 ̇ } {Y : 𝓥 ̇ } 
               → (f : X → Y) → seq-f-ucontinuous¹ (map f)
map-ucontinuous' f ε = ε , λ α β α∼ⁿβ k k<ε → ap f (α∼ⁿβ k k<ε)

zipWith-ucontinuous' : {X : 𝓤 ̇ } {Y : 𝓥 ̇ }
                → (f : X → X → Y)
                → seq-f-ucontinuous² (zipWith f)
zipWith-ucontinuous' f ε
 = (ε , ε)
 , (λ α₁ α₂ β₁ β₂ α∼ β∼ k k<ϵ
    → ap (λ - → f - (β₁ k)) (α∼ k k<ϵ)
    ∙ ap (f (α₂ k)) (β∼ k k<ϵ))

neg-ucontinuous' : seq-f-ucontinuous¹ neg
neg-ucontinuous' = map-ucontinuous' flip

mid-ucontinuous' : seq-f-ucontinuous² mid
mid-ucontinuous' = seq-f-ucontinuous¹²-comp div2 add2
                   div2-ucontinuous' (zipWith-ucontinuous' _+𝟛_)

bigMid'-ucontinuous' : seq-f-ucontinuousᴺ bigMid'
bigMid'-ucontinuous' ε = dδ ε , γ ε where
  d : ℕ → ℕ
  d 0 = 0
  d (succ ε) = succ (succ ε)
  δ : ℕ → ℕ
  δ 0 = 0
  δ (succ ε) = succ (succ (succ (δ ε)))
  dδ : ℕ → ℕ × ℕ
  dδ ε = d ε , δ ε
  pr₁δs< : (n : ℕ) → d n < d (succ n)
  pr₁δs< zero = ⋆
  pr₁δs< (succ n) = ≤-refl n
  γ : (ε : ℕ) → (x₁ x₂ : (ℕ → 𝟛ᴺ))
    → ((n : ℕ) → n < d ε → (x₁ n ∼ⁿ x₂ n) (δ ε))
    → (bigMid' x₁ ∼ⁿ bigMid' x₂) ε 
  γ (succ ε) αs βs αs∼ⁿβs zero k<ε
   = ap (λ - → (- +𝟛 -) +𝟝 (αs 0 1 +𝟛 αs 1 0)) (αs∼ⁿβs 0 ⋆ 0 ⋆)
   ∙ ap (λ - → (βs 0 0 +𝟛 βs 0 0) +𝟝 (- +𝟛 αs 1 0)) (αs∼ⁿβs 0 ⋆ 1 ⋆)
   ∙ ap (λ - → (βs 0 0 +𝟛 βs 0 0) +𝟝 (βs 0 1 +𝟛 -)) (αs∼ⁿβs 1 ⋆ 0 ⋆)
  γ (succ (succ ε)) αs βs αs∼ⁿβs (succ k)
   = γ (succ ε) αs' βs' αs∼ⁿβs' k
   where
    αs' = mid (tail (tail (αs 0))) (tail (αs 1)) ∶∶ tail (tail αs) 
    βs' = mid (tail (tail (βs 0))) (tail (βs 1)) ∶∶ tail (tail βs)
    αs∼ⁿβs' : (n : ℕ) → n < d (succ ε)
            → (αs' n ∼ⁿ βs' n) (δ (succ ε))
    αs∼ⁿβs' zero n<d i i<d
     = pr₂ (mid-ucontinuous' (δ (succ ε)))
       (tail (tail (αs 0))) (tail (tail (βs 0)))
       (tail       (αs 1) ) (tail       (βs 1) ) 
       (λ i → αs∼ⁿβs zero ⋆ (succ (succ i)))
       (λ i i≤δϵ → αs∼ⁿβs 1 ⋆ (succ i)
         (≤-trans i _ _ i≤δϵ (≤-succ (δ ε)))) i i<d
    αs∼ⁿβs' (succ n) n<d i i≤δϵ
     = αs∼ⁿβs (succ (succ n)) n<d i
         (≤-trans i (succ (succ (δ ε))) (succ (succ (succ (succ (succ (δ ε))))))
           i≤δϵ (≤-+ (δ ε) 3))
           
div4-ucontinuous' : seq-f-ucontinuous¹ div4
div4-ucontinuous' zero = 0 , λ α β _ k ()
div4-ucontinuous' (succ ε) = succ (succ ε) , γ ε where
  γ : (ε : ℕ) → (α β : ℕ → 𝟡) → (α ∼ⁿ β) (succ (succ ε))
    →  (div4 α ∼ⁿ div4 β) (succ ε) 
  γ ε α β α∼ⁿβ 0 ⋆ = ap (λ - → pr₁ (div4-aux - (α 1))) (α∼ⁿβ 0 ⋆)
                  ∙ ap (λ - → pr₁ (div4-aux (β 0) -)) (α∼ⁿβ 1 ⋆)
  γ (succ ε) α β α∼ⁿβ (succ k) = γ ε α' β' α∼ⁿβ' k
   where
    α' = pr₂ (div4-aux (α 0) (α 1)) ∶∶ (tail (tail α))
    β' = pr₂ (div4-aux (β 0) (β 1)) ∶∶ (tail (tail β))
    α∼ⁿβ' : (α' ∼ⁿ β') (succ (succ ε))
    α∼ⁿβ' 0 ⋆ = ap (λ - → pr₂ (div4-aux - (α 1))) (α∼ⁿβ 0 ⋆)
             ∙ ap (λ - → pr₂ (div4-aux (β 0) -)) (α∼ⁿβ 1 ⋆)
    α∼ⁿβ' (succ j) = α∼ⁿβ (succ (succ j))  

bigMid-ucontinuous' : seq-f-ucontinuousᴺ bigMid
bigMid-ucontinuous' ε = dδ , γ where
  dδ : ℕ × ℕ
  dδ = pr₁ (bigMid'-ucontinuous' (pr₁ (div4-ucontinuous' ε)))
  γ : (x₁ x₂ : ℕ → 𝟛ᴺ)
    → ((n : ℕ) → n < pr₁ dδ → ((x₁ n) ∼ⁿ (x₂ n)) (pr₂ dδ))
    → (bigMid x₁ ∼ⁿ bigMid x₂) ε 
  γ αs βs αs∼ⁿβs
   = pr₂ (div4-ucontinuous' ε)
       (bigMid' αs) (bigMid' βs)
       (pr₂ (bigMid'-ucontinuous' (pr₁ (div4-ucontinuous' ε)))
         αs βs αs∼ⁿβs)

mul-ucontinuous' : seq-f-ucontinuous² mul
mul-ucontinuous' ε = δ ε , γ ε where
  δ : ℕ → ℕ × ℕ
  δ ε = pr₁ (bigMid-ucontinuous' ε)
  γ : (ε : ℕ) → (α₁ α₂ : 𝟛ᴺ) (β₁ β₂ : 𝟛ᴺ)
    → (α₁ ∼ⁿ α₂) (pr₁ (δ ε)) → (β₁ ∼ⁿ β₂) (pr₂ (δ ε))
    → (mul α₁ β₁ ∼ⁿ mul α₂ β₂) ε
  γ ε α₁ α₂ β₁ β₂ α∼ β∼
   = pr₂ (bigMid-ucontinuous' ε) (zipWith digitMul α₁ (λ _ → β₁)) (zipWith digitMul α₂ (λ _ → β₂))
       (λ n n<d k k<δ → ap (_*𝟛 β₁ k) (α∼ n n<d)
                      ∙ ap (α₂ n *𝟛_) (β∼ k k<δ))

neg-ucontinuous
 : f-ucontinuous 𝟛ᴺ-ClosenessSpace 𝟛ᴺ-ClosenessSpace neg
neg-ucontinuous
 = seq-f-ucontinuous¹-to-closeness
     𝟛-is-discrete 𝟛-is-discrete
     neg neg-ucontinuous'

mid-ucontinuous
 : f-ucontinuous
     (×-ClosenessSpace 𝟛ᴺ-ClosenessSpace 𝟛ᴺ-ClosenessSpace)
     𝟛ᴺ-ClosenessSpace (uncurry mid)
mid-ucontinuous
 = seq-f-ucontinuous²-to-closeness
     𝟛-is-discrete 𝟛-is-discrete 𝟛-is-discrete
     mid mid-ucontinuous'

mul-ucontinuous
 : f-ucontinuous
     (×-ClosenessSpace 𝟛ᴺ-ClosenessSpace 𝟛ᴺ-ClosenessSpace)
     𝟛ᴺ-ClosenessSpace (uncurry mul)
mul-ucontinuous
 = seq-f-ucontinuous²-to-closeness
     𝟛-is-discrete 𝟛-is-discrete 𝟛-is-discrete
     mul mul-ucontinuous'

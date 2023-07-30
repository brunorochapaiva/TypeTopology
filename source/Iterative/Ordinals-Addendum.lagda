Martin Escardo & Tom de Jong, July 2023.

More about iterative ordinals and their relation to iterative (multi)sets.

\begin{code}

{-# OPTIONS --safe --without-K --exact-split --lossy-unification #-}

open import MLTT.Spartan
open import UF.Univalence

module Iterative.Ordinals-Addendum
        (𝓤 : Universe)
        (ua : Univalence)
       where

open import UF.FunExt
open import UF.UA-FunExt

private
 𝓤⁺ : Universe
 𝓤⁺ = 𝓤 ⁺

 fe : Fun-Ext
 fe = Univalence-gives-Fun-Ext ua

 fe' : FunExt
 fe' 𝓤 𝓥 = fe {𝓤} {𝓥}

\end{code}

There are more imports than needed here. But let's keep them until we
add all we wanted to add, and clean-up when we finish.

\begin{code}

open import Iterative.Multisets 𝓤
open import Iterative.Sets 𝓤 ua
open import Ordinals.Equivalence
open import Ordinals.Notions
open import Ordinals.OrdinalOfOrdinals ua
open import Ordinals.Type hiding (Ord)
open import Ordinals.Underlying
open import Ordinals.WellOrderTransport
open import UF.Equiv-FunExt
open import UF.Base
open import UF.Embeddings
open import UF.Equiv
open import UF.EquivalenceExamples
open import UF.PairFun
open import UF.Size
open import UF.Subsingletons
open import UF.Subsingletons-FunExt
open import W.Type

open import InjectiveTypes.Blackboard fe'
open import Ordinals.Injectivity
open import Iterative.Ordinals 𝓤 ua

open ordinals-injectivity fe'

private
 e : Ordinal 𝓤 ↪ Ordinal 𝓤⁺
 e = Ordinal-embedded-in-next-Ordinal

 almost-a-retraction-𝕄 : Σ f ꞉ (𝕄 → Ordinal 𝓤⁺) , f ∘ Ord-to-𝕄 ∼ ⌊ e ⌋
 almost-a-retraction-𝕄 = Ordinal-is-ainjective (ua 𝓤⁺)
                          Ord-to-𝕄
                          Ord-to-𝕄-is-embedding
                          ⌊ e ⌋

 almost-a-retraction-𝕍 : Σ f ꞉ (𝕍 → Ordinal 𝓤⁺) , f ∘ Ord-to-𝕍 ∼ ⌊ e ⌋
 almost-a-retraction-𝕍 = Ordinal-is-ainjective (ua 𝓤⁺)
                          Ord-to-𝕍
                          Ord-to-𝕍-is-embedding
                          ⌊ e ⌋
\end{code}

To get retractions we would like to extend the identity functions,
rather than ⌊ e ⌋, but the universe levels get on the way. Unless we
assume propositional resizing.

\begin{code}

open import UF.Retracts

Ord-is-retract-of-𝕄 : propositional-resizing 𝓤⁺ 𝓤
                    → retract Ord of 𝕄
Ord-is-retract-of-𝕄 pe = embedding-retract Ord 𝕄 Ord-to-𝕄
                           Ord-to-𝕄-is-embedding
                           (ainjective-resizing {𝓤} {𝓤} pe (Ordinal 𝓤)
                             (Ordinal-is-ainjective (ua 𝓤)))

Ord-is-retract-of-𝕍 : propositional-resizing 𝓤⁺ 𝓤
                    → retract Ord of 𝕍
Ord-is-retract-of-𝕍 pe = embedding-retract Ord 𝕍 Ord-to-𝕍
                          Ord-to-𝕍-is-embedding
                          (ainjective-resizing {𝓤} {𝓤} pe (Ordinal 𝓤)
                            (Ordinal-is-ainjective (ua 𝓤)))
\end{code}

TODO. Can we get the same conclusion without propositional resizing?

Added 28 July 2023: Yes, we can: the desired map 𝕍 → Ord is constructed (for
another presentation of 𝕍) in Ordinals.CumulativeHierarchy.

TODO. Implement this in Agda.

\begin{code}

{-
open import UF.PropTrunc
open import UF.Quotient -- hiding (is-prop-valued)

open import Ordinals.Arithmetic fe'
open import Ordinals.ArithmeticProperties ua
open import Ordinals.OrdinalOfOrdinalsSuprema ua

module 𝕍-to-Ord-construction
        (pt : propositional-truncations-exist)
        (sq : set-quotients-exist)
       where

 open suprema pt (set-replacement-from-set-quotients sq pt)

 𝕍-to-Ord : 𝕍 → Ord
 𝕍-to-Ord = 𝕍-induction (λ _ → Ord) f
  where
   f : (X : 𝓤 ̇  ) (ϕ : X → 𝕍) (e : is-embedding ϕ)
     → ((x : X) → Ord) → Ord
   f X ϕ e r = sup (λ x → r x +ₒ 𝟙ₒ)

 𝕍-to-Ord-behaviour : (A : 𝕍)
                    → 𝕍-to-Ord A ＝ sup (λ x → 𝕍-to-Ord (𝕍-forest A x) +ₒ 𝟙ₒ)
 𝕍-to-Ord-behaviour A =
  𝕍-to-Ord A ＝⟨ ap 𝕍-to-Ord ((𝕍-η A) ⁻¹) ⟩
  𝕍-to-Ord {!!} ＝⟨ {!!} ⟩
  {!!} ∎
-}

\end{code}

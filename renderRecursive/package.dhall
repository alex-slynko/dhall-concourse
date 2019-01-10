  λ(JSON : Type)
→ λ(toJSON : ∀(T : Type) → ∀(t : T) → JSON)
→ { job =
	  ./job.dhall JSON toJSON
  , step =
	  ./step.dhall JSON toJSON
  , steps =
	  ./steps.dhall JSON toJSON
  }
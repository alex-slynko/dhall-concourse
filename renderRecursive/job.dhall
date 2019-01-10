  λ(JSON : Type)
→ λ(toJSON : ∀(Value : Type) → ∀(v : Value) → JSON)
→ let Types =
		../types/package.dhall

  let renderStep = ./step.dhall JSON toJSON

  let RenderedJob =
		{ name :
			Text
		, plan :
			List JSON
		, serial :
			Optional Bool
		, build_logs_to_retain :
			Optional Natural
		, serial_groups :
			Optional (List Text)
		, max_in_flight :
			Optional Natural
		, public :
			Optional Bool
		, disable_manual_trigger :
			Optional Bool
		, interruptible :
			Optional Bool
		, on_success :
			Optional JSON
		, on_failure :
			Optional JSON
		, on_abort :
			Optional JSON
		, ensure :
			Optional JSON
		}

  let Prelude =
		https://prelude.dhall-lang.org/package.dhall sha256:534e4a9e687ba74bfac71b30fc27aa269c0465087ef79bf483e876781602a454

  let renderOptionalStep
	  : Optional Types.Step → Optional JSON
	  = Prelude.`Optional`.map Types.Step JSON renderStep

  let renderJob
	  : Types.Job → JSON
	  =   λ(j : Types.Job)
		→ toJSON
		  RenderedJob
		  (   j
			⫽ { plan =
				  Prelude.`List`.map Types.Step JSON renderStep j.plan
			  , on_success =
				  renderOptionalStep j.on_success
			  , on_failure =
				  renderOptionalStep j.on_failure
			  , on_abort =
				  renderOptionalStep j.on_abort
			  , ensure =
				  renderOptionalStep j.ensure
			  }
		  )

  in  renderJob
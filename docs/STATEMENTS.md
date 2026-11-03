# Exact statements
Lean text below is copied verbatim from `ClayStatement/Fefferman.lean` by the build script that wrote this file; it is not retyped.

## `Clay.NavierStokes.StatementA`
```lean
/-- Standard basis vector e_j. -/
def e (j : Fin 3) : E3 := EuclideanSpace.single j 1

/-- Spatial partial derivative ∂_j at a fixed time. -/
def dx {F : Type*} [NormedAddCommGroup F] [NormedSpace ℝ F]
    (g : E3 → F) (j : Fin 3) (x : E3) : F :=
  fderiv ℝ g x (e j)

/-- Component g_j = ⟪g, e_j⟫. -/
def comp (v : E3) (j : Fin 3) : ℝ := ⟪v, e j⟫

def lap (g : E3 → E3) (x : E3) : E3 := ∑ j, dx (fun y => dx g j y) j x

def grad (q : E3 → ℝ) (x : E3) : E3 := ∑ i, dx q i x • e i

def div (g : E3 → E3) (x : E3) : ℝ := ∑ j, comp (dx g j x) j

/-- (u·∇)u. -/
def advect (g : E3 → E3) (x : E3) : E3 := ∑ j, comp (g x) j • dx g j x

/-- The closed half-space ℝ³ × [0, ∞), written as {(t, x) | 0 ≤ t}. -/
def halfSpace : Set (ℝ × E3) := {z | 0 ≤ z.1}

/-- (1): ∂_t u + (u·∇)u = νΔu − ∇p + f, for t ≥ 0 (one-sided at t = 0). -/
def NSEq (ν : ℝ) (u : ℝ → E3 → E3) (p : ℝ → E3 → ℝ) (f : ℝ → E3 → E3) : Prop :=
  ∀ t : ℝ, 0 ≤ t → ∀ x : E3,
    derivWithin (fun s => u s x) (Set.Ici 0) t + advect (u t) x
      = ν • lap (u t) x - grad (p t) x + f t x

/-- (2): div u = 0. -/
def DivFree (u : ℝ → E3 → E3) : Prop := ∀ t : ℝ, 0 ≤ t → ∀ x, div (u t) x = 0

/-- (3): u(x,0) = u°(x). -/
def Initial (u : ℝ → E3 → E3) (u0 : E3 → E3) : Prop := ∀ x, u 0 x = u0 x

/-- (6)/(11): smooth on ℝ³ × [0,∞). -/
def SmoothHalf {F : Type*} [NormedAddCommGroup F] [NormedSpace ℝ F]
    (g : ℝ → E3 → F) : Prop :=
  ContDiffOn ℝ (⊤ : ℕ∞) (fun z : ℝ × E3 => g z.1 z.2) halfSpace

/-- Smooth, divergence-free initial datum. -/
def SmoothDivFree (u0 : E3 → E3) : Prop :=
  ContDiff ℝ (⊤ : ℕ∞) u0 ∧ ∀ x, div u0 x = 0

/-- (4): |∂^α u°(x)| ≤ C_{αK} (1+|x|)^{−K}. -/
def Decay (u0 : E3 → E3) : Prop :=
  ∀ (n : ℕ) (K : ℝ), ∃ C : ℝ, ∀ x, ‖iteratedFDeriv ℝ n u0 x‖ ≤ C / (1 + ‖x‖) ^ K

/-- (5): f smooth with |∂_x^α ∂_t^m f| ≤ C (1+|x|+t)^{−K} for t ≥ 0. -/
def ForceR3 (f : ℝ → E3 → E3) : Prop :=
  ContDiffOn ℝ (⊤ : ℕ∞) (fun z : ℝ × E3 => f z.1 z.2) halfSpace ∧
  ∀ (n : ℕ) (K : ℝ), ∃ C : ℝ, ∀ t : ℝ, 0 ≤ t → ∀ x,
    ‖iteratedFDerivWithin ℝ n (fun z : ℝ × E3 => f z.1 z.2) halfSpace (t, x)‖
      ≤ C / (1 + ‖x‖ + t) ^ K

/-- (7): bounded energy, ∫ |u(x,t)|² dx < C for all t ≥ 0. -/
def FiniteEnergy (u : ℝ → E3 → E3) : Prop :=
  ∃ C : ℝ, ∀ t : ℝ, 0 ≤ t →
    Integrable (fun x => ‖u t x‖ ^ 2) ∧ ∫ x, ‖u t x‖ ^ 2 < C

/-- (8): u°(x + e_j) = u°(x). -/
def PeriodicDatum (u0 : E3 → E3) : Prop := ∀ j x, u0 (x + e j) = u0 x

/-- (10): space-periodic in x for every t ≥ 0. -/
def PeriodicField {F : Type*} (g : ℝ → E3 → F) : Prop :=
  ∀ t : ℝ, 0 ≤ t → ∀ j x, g t (x + e j) = g t x

/-- (9): f periodic in x, smooth, with |∂_x^α ∂_t^m f| ≤ C (1+t)^{−K} for t ≥ 0. -/
def ForceTorus (f : ℝ → E3 → E3) : Prop :=
  ContDiffOn ℝ (⊤ : ℕ∞) (fun z : ℝ × E3 => f z.1 z.2) halfSpace ∧
  (∀ t : ℝ, 0 ≤ t → ∀ j x, f t (x + e j) = f t x) ∧
  ∀ (n : ℕ) (K : ℝ), ∃ C : ℝ, ∀ t : ℝ, 0 ≤ t → ∀ x,
    ‖iteratedFDerivWithin ℝ n (fun z : ℝ × E3 => f z.1 z.2) halfSpace (t, x)‖
      ≤ C / (1 + t) ^ K

def zeroForce : ℝ → E3 → E3 := fun _ _ => 0

/-- Solution class on ℝ³: (1), (2), (3), (6), (7). -/
def SolR3 (ν : ℝ) (u0 : E3 → E3) (f : ℝ → E3 → E3) : Prop :=
  ∃ (u : ℝ → E3 → E3) (p : ℝ → E3 → ℝ),
    NSEq ν u p f ∧ DivFree u ∧ Initial u u0 ∧
    SmoothHalf u ∧ SmoothHalf p ∧ FiniteEnergy u

/-- Solution class on the torus: (1), (2), (3), (10), (11). -/
def SolTorus (ν : ℝ) (u0 : E3 → E3) (f : ℝ → E3 → E3) : Prop :=
  ∃ (u : ℝ → E3 → E3) (p : ℝ → E3 → ℝ),
    NSEq ν u p f ∧ DivFree u ∧ Initial u u0 ∧
    PeriodicField u ∧ PeriodicField p ∧ SmoothHalf u ∧ SmoothHalf p

/-- (A) Existence and smoothness of Navier–Stokes solutions on ℝ³. -/
def StatementA : Prop :=
  ∀ ν : ℝ, 0 < ν → ∀ u0 : E3 → E3,
    SmoothDivFree u0 → Decay u0 → SolR3 ν u0 zeroForce
```

## `Clay.NavierStokes.StatementB`
```lean
/-- Standard basis vector e_j. -/
def e (j : Fin 3) : E3 := EuclideanSpace.single j 1

/-- Spatial partial derivative ∂_j at a fixed time. -/
def dx {F : Type*} [NormedAddCommGroup F] [NormedSpace ℝ F]
    (g : E3 → F) (j : Fin 3) (x : E3) : F :=
  fderiv ℝ g x (e j)

/-- Component g_j = ⟪g, e_j⟫. -/
def comp (v : E3) (j : Fin 3) : ℝ := ⟪v, e j⟫

def lap (g : E3 → E3) (x : E3) : E3 := ∑ j, dx (fun y => dx g j y) j x

def grad (q : E3 → ℝ) (x : E3) : E3 := ∑ i, dx q i x • e i

def div (g : E3 → E3) (x : E3) : ℝ := ∑ j, comp (dx g j x) j

/-- (u·∇)u. -/
def advect (g : E3 → E3) (x : E3) : E3 := ∑ j, comp (g x) j • dx g j x

/-- The closed half-space ℝ³ × [0, ∞), written as {(t, x) | 0 ≤ t}. -/
def halfSpace : Set (ℝ × E3) := {z | 0 ≤ z.1}

/-- (1): ∂_t u + (u·∇)u = νΔu − ∇p + f, for t ≥ 0 (one-sided at t = 0). -/
def NSEq (ν : ℝ) (u : ℝ → E3 → E3) (p : ℝ → E3 → ℝ) (f : ℝ → E3 → E3) : Prop :=
  ∀ t : ℝ, 0 ≤ t → ∀ x : E3,
    derivWithin (fun s => u s x) (Set.Ici 0) t + advect (u t) x
      = ν • lap (u t) x - grad (p t) x + f t x

/-- (2): div u = 0. -/
def DivFree (u : ℝ → E3 → E3) : Prop := ∀ t : ℝ, 0 ≤ t → ∀ x, div (u t) x = 0

/-- (3): u(x,0) = u°(x). -/
def Initial (u : ℝ → E3 → E3) (u0 : E3 → E3) : Prop := ∀ x, u 0 x = u0 x

/-- (6)/(11): smooth on ℝ³ × [0,∞). -/
def SmoothHalf {F : Type*} [NormedAddCommGroup F] [NormedSpace ℝ F]
    (g : ℝ → E3 → F) : Prop :=
  ContDiffOn ℝ (⊤ : ℕ∞) (fun z : ℝ × E3 => g z.1 z.2) halfSpace

/-- Smooth, divergence-free initial datum. -/
def SmoothDivFree (u0 : E3 → E3) : Prop :=
  ContDiff ℝ (⊤ : ℕ∞) u0 ∧ ∀ x, div u0 x = 0

/-- (4): |∂^α u°(x)| ≤ C_{αK} (1+|x|)^{−K}. -/
def Decay (u0 : E3 → E3) : Prop :=
  ∀ (n : ℕ) (K : ℝ), ∃ C : ℝ, ∀ x, ‖iteratedFDeriv ℝ n u0 x‖ ≤ C / (1 + ‖x‖) ^ K

/-- (5): f smooth with |∂_x^α ∂_t^m f| ≤ C (1+|x|+t)^{−K} for t ≥ 0. -/
def ForceR3 (f : ℝ → E3 → E3) : Prop :=
  ContDiffOn ℝ (⊤ : ℕ∞) (fun z : ℝ × E3 => f z.1 z.2) halfSpace ∧
  ∀ (n : ℕ) (K : ℝ), ∃ C : ℝ, ∀ t : ℝ, 0 ≤ t → ∀ x,
    ‖iteratedFDerivWithin ℝ n (fun z : ℝ × E3 => f z.1 z.2) halfSpace (t, x)‖
      ≤ C / (1 + ‖x‖ + t) ^ K

/-- (7): bounded energy, ∫ |u(x,t)|² dx < C for all t ≥ 0. -/
def FiniteEnergy (u : ℝ → E3 → E3) : Prop :=
  ∃ C : ℝ, ∀ t : ℝ, 0 ≤ t →
    Integrable (fun x => ‖u t x‖ ^ 2) ∧ ∫ x, ‖u t x‖ ^ 2 < C

/-- (8): u°(x + e_j) = u°(x). -/
def PeriodicDatum (u0 : E3 → E3) : Prop := ∀ j x, u0 (x + e j) = u0 x

/-- (10): space-periodic in x for every t ≥ 0. -/
def PeriodicField {F : Type*} (g : ℝ → E3 → F) : Prop :=
  ∀ t : ℝ, 0 ≤ t → ∀ j x, g t (x + e j) = g t x

/-- (9): f periodic in x, smooth, with |∂_x^α ∂_t^m f| ≤ C (1+t)^{−K} for t ≥ 0. -/
def ForceTorus (f : ℝ → E3 → E3) : Prop :=
  ContDiffOn ℝ (⊤ : ℕ∞) (fun z : ℝ × E3 => f z.1 z.2) halfSpace ∧
  (∀ t : ℝ, 0 ≤ t → ∀ j x, f t (x + e j) = f t x) ∧
  ∀ (n : ℕ) (K : ℝ), ∃ C : ℝ, ∀ t : ℝ, 0 ≤ t → ∀ x,
    ‖iteratedFDerivWithin ℝ n (fun z : ℝ × E3 => f z.1 z.2) halfSpace (t, x)‖
      ≤ C / (1 + t) ^ K

def zeroForce : ℝ → E3 → E3 := fun _ _ => 0

/-- Solution class on ℝ³: (1), (2), (3), (6), (7). -/
def SolR3 (ν : ℝ) (u0 : E3 → E3) (f : ℝ → E3 → E3) : Prop :=
  ∃ (u : ℝ → E3 → E3) (p : ℝ → E3 → ℝ),
    NSEq ν u p f ∧ DivFree u ∧ Initial u u0 ∧
    SmoothHalf u ∧ SmoothHalf p ∧ FiniteEnergy u

/-- Solution class on the torus: (1), (2), (3), (10), (11). -/
def SolTorus (ν : ℝ) (u0 : E3 → E3) (f : ℝ → E3 → E3) : Prop :=
  ∃ (u : ℝ → E3 → E3) (p : ℝ → E3 → ℝ),
    NSEq ν u p f ∧ DivFree u ∧ Initial u u0 ∧
    PeriodicField u ∧ PeriodicField p ∧ SmoothHalf u ∧ SmoothHalf p

/-- (A) Existence and smoothness of Navier–Stokes solutions on ℝ³. -/
def StatementA : Prop :=
  ∀ ν : ℝ, 0 < ν → ∀ u0 : E3 → E3,
    SmoothDivFree u0 → Decay u0 → SolR3 ν u0 zeroForce

/-- (B) Existence and smoothness of Navier–Stokes solutions on ℝ³/ℤ³. -/
def StatementB : Prop :=
  ∀ ν : ℝ, 0 < ν → ∀ u0 : E3 → E3,
    SmoothDivFree u0 → PeriodicDatum u0 → SolTorus ν u0 zeroForce
```

## `Clay.NavierStokes.StatementC`
```lean
/-- Standard basis vector e_j. -/
def e (j : Fin 3) : E3 := EuclideanSpace.single j 1

/-- Spatial partial derivative ∂_j at a fixed time. -/
def dx {F : Type*} [NormedAddCommGroup F] [NormedSpace ℝ F]
    (g : E3 → F) (j : Fin 3) (x : E3) : F :=
  fderiv ℝ g x (e j)

/-- Component g_j = ⟪g, e_j⟫. -/
def comp (v : E3) (j : Fin 3) : ℝ := ⟪v, e j⟫

def lap (g : E3 → E3) (x : E3) : E3 := ∑ j, dx (fun y => dx g j y) j x

def grad (q : E3 → ℝ) (x : E3) : E3 := ∑ i, dx q i x • e i

def div (g : E3 → E3) (x : E3) : ℝ := ∑ j, comp (dx g j x) j

/-- (u·∇)u. -/
def advect (g : E3 → E3) (x : E3) : E3 := ∑ j, comp (g x) j • dx g j x

/-- The closed half-space ℝ³ × [0, ∞), written as {(t, x) | 0 ≤ t}. -/
def halfSpace : Set (ℝ × E3) := {z | 0 ≤ z.1}

/-- (1): ∂_t u + (u·∇)u = νΔu − ∇p + f, for t ≥ 0 (one-sided at t = 0). -/
def NSEq (ν : ℝ) (u : ℝ → E3 → E3) (p : ℝ → E3 → ℝ) (f : ℝ → E3 → E3) : Prop :=
  ∀ t : ℝ, 0 ≤ t → ∀ x : E3,
    derivWithin (fun s => u s x) (Set.Ici 0) t + advect (u t) x
      = ν • lap (u t) x - grad (p t) x + f t x

/-- (2): div u = 0. -/
def DivFree (u : ℝ → E3 → E3) : Prop := ∀ t : ℝ, 0 ≤ t → ∀ x, div (u t) x = 0

/-- (3): u(x,0) = u°(x). -/
def Initial (u : ℝ → E3 → E3) (u0 : E3 → E3) : Prop := ∀ x, u 0 x = u0 x

/-- (6)/(11): smooth on ℝ³ × [0,∞). -/
def SmoothHalf {F : Type*} [NormedAddCommGroup F] [NormedSpace ℝ F]
    (g : ℝ → E3 → F) : Prop :=
  ContDiffOn ℝ (⊤ : ℕ∞) (fun z : ℝ × E3 => g z.1 z.2) halfSpace

/-- Smooth, divergence-free initial datum. -/
def SmoothDivFree (u0 : E3 → E3) : Prop :=
  ContDiff ℝ (⊤ : ℕ∞) u0 ∧ ∀ x, div u0 x = 0

/-- (4): |∂^α u°(x)| ≤ C_{αK} (1+|x|)^{−K}. -/
def Decay (u0 : E3 → E3) : Prop :=
  ∀ (n : ℕ) (K : ℝ), ∃ C : ℝ, ∀ x, ‖iteratedFDeriv ℝ n u0 x‖ ≤ C / (1 + ‖x‖) ^ K

/-- (5): f smooth with |∂_x^α ∂_t^m f| ≤ C (1+|x|+t)^{−K} for t ≥ 0. -/
def ForceR3 (f : ℝ → E3 → E3) : Prop :=
  ContDiffOn ℝ (⊤ : ℕ∞) (fun z : ℝ × E3 => f z.1 z.2) halfSpace ∧
  ∀ (n : ℕ) (K : ℝ), ∃ C : ℝ, ∀ t : ℝ, 0 ≤ t → ∀ x,
    ‖iteratedFDerivWithin ℝ n (fun z : ℝ × E3 => f z.1 z.2) halfSpace (t, x)‖
      ≤ C / (1 + ‖x‖ + t) ^ K

/-- (7): bounded energy, ∫ |u(x,t)|² dx < C for all t ≥ 0. -/
def FiniteEnergy (u : ℝ → E3 → E3) : Prop :=
  ∃ C : ℝ, ∀ t : ℝ, 0 ≤ t →
    Integrable (fun x => ‖u t x‖ ^ 2) ∧ ∫ x, ‖u t x‖ ^ 2 < C

/-- (8): u°(x + e_j) = u°(x). -/
def PeriodicDatum (u0 : E3 → E3) : Prop := ∀ j x, u0 (x + e j) = u0 x

/-- (10): space-periodic in x for every t ≥ 0. -/
def PeriodicField {F : Type*} (g : ℝ → E3 → F) : Prop :=
  ∀ t : ℝ, 0 ≤ t → ∀ j x, g t (x + e j) = g t x

/-- (9): f periodic in x, smooth, with |∂_x^α ∂_t^m f| ≤ C (1+t)^{−K} for t ≥ 0. -/
def ForceTorus (f : ℝ → E3 → E3) : Prop :=
  ContDiffOn ℝ (⊤ : ℕ∞) (fun z : ℝ × E3 => f z.1 z.2) halfSpace ∧
  (∀ t : ℝ, 0 ≤ t → ∀ j x, f t (x + e j) = f t x) ∧
  ∀ (n : ℕ) (K : ℝ), ∃ C : ℝ, ∀ t : ℝ, 0 ≤ t → ∀ x,
    ‖iteratedFDerivWithin ℝ n (fun z : ℝ × E3 => f z.1 z.2) halfSpace (t, x)‖
      ≤ C / (1 + t) ^ K

def zeroForce : ℝ → E3 → E3 := fun _ _ => 0

/-- Solution class on ℝ³: (1), (2), (3), (6), (7). -/
def SolR3 (ν : ℝ) (u0 : E3 → E3) (f : ℝ → E3 → E3) : Prop :=
  ∃ (u : ℝ → E3 → E3) (p : ℝ → E3 → ℝ),
    NSEq ν u p f ∧ DivFree u ∧ Initial u u0 ∧
    SmoothHalf u ∧ SmoothHalf p ∧ FiniteEnergy u

/-- Solution class on the torus: (1), (2), (3), (10), (11). -/
def SolTorus (ν : ℝ) (u0 : E3 → E3) (f : ℝ → E3 → E3) : Prop :=
  ∃ (u : ℝ → E3 → E3) (p : ℝ → E3 → ℝ),
    NSEq ν u p f ∧ DivFree u ∧ Initial u u0 ∧
    PeriodicField u ∧ PeriodicField p ∧ SmoothHalf u ∧ SmoothHalf p

/-- (A) Existence and smoothness of Navier–Stokes solutions on ℝ³. -/
def StatementA : Prop :=
  ∀ ν : ℝ, 0 < ν → ∀ u0 : E3 → E3,
    SmoothDivFree u0 → Decay u0 → SolR3 ν u0 zeroForce

/-- (B) Existence and smoothness of Navier–Stokes solutions on ℝ³/ℤ³. -/
def StatementB : Prop :=
  ∀ ν : ℝ, 0 < ν → ∀ u0 : E3 → E3,
    SmoothDivFree u0 → PeriodicDatum u0 → SolTorus ν u0 zeroForce

/-- (C) Breakdown of Navier–Stokes solutions on ℝ³. -/
def StatementC : Prop :=
  ∀ ν : ℝ, 0 < ν → ∃ (u0 : E3 → E3) (f : ℝ → E3 → E3),
    SmoothDivFree u0 ∧ Decay u0 ∧ ForceR3 f ∧ ¬ SolR3 ν u0 f
```

## `Clay.NavierStokes.StatementD`
```lean
/-- Standard basis vector e_j. -/
def e (j : Fin 3) : E3 := EuclideanSpace.single j 1

/-- Spatial partial derivative ∂_j at a fixed time. -/
def dx {F : Type*} [NormedAddCommGroup F] [NormedSpace ℝ F]
    (g : E3 → F) (j : Fin 3) (x : E3) : F :=
  fderiv ℝ g x (e j)

/-- Component g_j = ⟪g, e_j⟫. -/
def comp (v : E3) (j : Fin 3) : ℝ := ⟪v, e j⟫

def lap (g : E3 → E3) (x : E3) : E3 := ∑ j, dx (fun y => dx g j y) j x

def grad (q : E3 → ℝ) (x : E3) : E3 := ∑ i, dx q i x • e i

def div (g : E3 → E3) (x : E3) : ℝ := ∑ j, comp (dx g j x) j

/-- (u·∇)u. -/
def advect (g : E3 → E3) (x : E3) : E3 := ∑ j, comp (g x) j • dx g j x

/-- The closed half-space ℝ³ × [0, ∞), written as {(t, x) | 0 ≤ t}. -/
def halfSpace : Set (ℝ × E3) := {z | 0 ≤ z.1}

/-- (1): ∂_t u + (u·∇)u = νΔu − ∇p + f, for t ≥ 0 (one-sided at t = 0). -/
def NSEq (ν : ℝ) (u : ℝ → E3 → E3) (p : ℝ → E3 → ℝ) (f : ℝ → E3 → E3) : Prop :=
  ∀ t : ℝ, 0 ≤ t → ∀ x : E3,
    derivWithin (fun s => u s x) (Set.Ici 0) t + advect (u t) x
      = ν • lap (u t) x - grad (p t) x + f t x

/-- (2): div u = 0. -/
def DivFree (u : ℝ → E3 → E3) : Prop := ∀ t : ℝ, 0 ≤ t → ∀ x, div (u t) x = 0

/-- (3): u(x,0) = u°(x). -/
def Initial (u : ℝ → E3 → E3) (u0 : E3 → E3) : Prop := ∀ x, u 0 x = u0 x

/-- (6)/(11): smooth on ℝ³ × [0,∞). -/
def SmoothHalf {F : Type*} [NormedAddCommGroup F] [NormedSpace ℝ F]
    (g : ℝ → E3 → F) : Prop :=
  ContDiffOn ℝ (⊤ : ℕ∞) (fun z : ℝ × E3 => g z.1 z.2) halfSpace

/-- Smooth, divergence-free initial datum. -/
def SmoothDivFree (u0 : E3 → E3) : Prop :=
  ContDiff ℝ (⊤ : ℕ∞) u0 ∧ ∀ x, div u0 x = 0

/-- (4): |∂^α u°(x)| ≤ C_{αK} (1+|x|)^{−K}. -/
def Decay (u0 : E3 → E3) : Prop :=
  ∀ (n : ℕ) (K : ℝ), ∃ C : ℝ, ∀ x, ‖iteratedFDeriv ℝ n u0 x‖ ≤ C / (1 + ‖x‖) ^ K

/-- (5): f smooth with |∂_x^α ∂_t^m f| ≤ C (1+|x|+t)^{−K} for t ≥ 0. -/
def ForceR3 (f : ℝ → E3 → E3) : Prop :=
  ContDiffOn ℝ (⊤ : ℕ∞) (fun z : ℝ × E3 => f z.1 z.2) halfSpace ∧
  ∀ (n : ℕ) (K : ℝ), ∃ C : ℝ, ∀ t : ℝ, 0 ≤ t → ∀ x,
    ‖iteratedFDerivWithin ℝ n (fun z : ℝ × E3 => f z.1 z.2) halfSpace (t, x)‖
      ≤ C / (1 + ‖x‖ + t) ^ K

/-- (7): bounded energy, ∫ |u(x,t)|² dx < C for all t ≥ 0. -/
def FiniteEnergy (u : ℝ → E3 → E3) : Prop :=
  ∃ C : ℝ, ∀ t : ℝ, 0 ≤ t →
    Integrable (fun x => ‖u t x‖ ^ 2) ∧ ∫ x, ‖u t x‖ ^ 2 < C

/-- (8): u°(x + e_j) = u°(x). -/
def PeriodicDatum (u0 : E3 → E3) : Prop := ∀ j x, u0 (x + e j) = u0 x

/-- (10): space-periodic in x for every t ≥ 0. -/
def PeriodicField {F : Type*} (g : ℝ → E3 → F) : Prop :=
  ∀ t : ℝ, 0 ≤ t → ∀ j x, g t (x + e j) = g t x

/-- (9): f periodic in x, smooth, with |∂_x^α ∂_t^m f| ≤ C (1+t)^{−K} for t ≥ 0. -/
def ForceTorus (f : ℝ → E3 → E3) : Prop :=
  ContDiffOn ℝ (⊤ : ℕ∞) (fun z : ℝ × E3 => f z.1 z.2) halfSpace ∧
  (∀ t : ℝ, 0 ≤ t → ∀ j x, f t (x + e j) = f t x) ∧
  ∀ (n : ℕ) (K : ℝ), ∃ C : ℝ, ∀ t : ℝ, 0 ≤ t → ∀ x,
    ‖iteratedFDerivWithin ℝ n (fun z : ℝ × E3 => f z.1 z.2) halfSpace (t, x)‖
      ≤ C / (1 + t) ^ K

def zeroForce : ℝ → E3 → E3 := fun _ _ => 0

/-- Solution class on ℝ³: (1), (2), (3), (6), (7). -/
def SolR3 (ν : ℝ) (u0 : E3 → E3) (f : ℝ → E3 → E3) : Prop :=
  ∃ (u : ℝ → E3 → E3) (p : ℝ → E3 → ℝ),
    NSEq ν u p f ∧ DivFree u ∧ Initial u u0 ∧
    SmoothHalf u ∧ SmoothHalf p ∧ FiniteEnergy u

/-- Solution class on the torus: (1), (2), (3), (10), (11). -/
def SolTorus (ν : ℝ) (u0 : E3 → E3) (f : ℝ → E3 → E3) : Prop :=
  ∃ (u : ℝ → E3 → E3) (p : ℝ → E3 → ℝ),
    NSEq ν u p f ∧ DivFree u ∧ Initial u u0 ∧
    PeriodicField u ∧ PeriodicField p ∧ SmoothHalf u ∧ SmoothHalf p

/-- (A) Existence and smoothness of Navier–Stokes solutions on ℝ³. -/
def StatementA : Prop :=
  ∀ ν : ℝ, 0 < ν → ∀ u0 : E3 → E3,
    SmoothDivFree u0 → Decay u0 → SolR3 ν u0 zeroForce

/-- (B) Existence and smoothness of Navier–Stokes solutions on ℝ³/ℤ³. -/
def StatementB : Prop :=
  ∀ ν : ℝ, 0 < ν → ∀ u0 : E3 → E3,
    SmoothDivFree u0 → PeriodicDatum u0 → SolTorus ν u0 zeroForce

/-- (C) Breakdown of Navier–Stokes solutions on ℝ³. -/
def StatementC : Prop :=
  ∀ ν : ℝ, 0 < ν → ∃ (u0 : E3 → E3) (f : ℝ → E3 → E3),
    SmoothDivFree u0 ∧ Decay u0 ∧ ForceR3 f ∧ ¬ SolR3 ν u0 f

/-- (D) Breakdown of Navier–Stokes solutions on ℝ³/ℤ³. -/
def StatementD : Prop :=
  ∀ ν : ℝ, 0 < ν → ∃ (u0 : E3 → E3) (f : ℝ → E3 → E3),
    SmoothDivFree u0 ∧ PeriodicDatum u0 ∧ ForceTorus f ∧ ¬ SolTorus ν u0 f
```

## `Clay.NavierStokes.ClayNavierStokes`
```lean
/-- Standard basis vector e_j. -/
def e (j : Fin 3) : E3 := EuclideanSpace.single j 1

/-- Spatial partial derivative ∂_j at a fixed time. -/
def dx {F : Type*} [NormedAddCommGroup F] [NormedSpace ℝ F]
    (g : E3 → F) (j : Fin 3) (x : E3) : F :=
  fderiv ℝ g x (e j)

/-- Component g_j = ⟪g, e_j⟫. -/
def comp (v : E3) (j : Fin 3) : ℝ := ⟪v, e j⟫

def lap (g : E3 → E3) (x : E3) : E3 := ∑ j, dx (fun y => dx g j y) j x

def grad (q : E3 → ℝ) (x : E3) : E3 := ∑ i, dx q i x • e i

def div (g : E3 → E3) (x : E3) : ℝ := ∑ j, comp (dx g j x) j

/-- (u·∇)u. -/
def advect (g : E3 → E3) (x : E3) : E3 := ∑ j, comp (g x) j • dx g j x

/-- The closed half-space ℝ³ × [0, ∞), written as {(t, x) | 0 ≤ t}. -/
def halfSpace : Set (ℝ × E3) := {z | 0 ≤ z.1}

/-- (1): ∂_t u + (u·∇)u = νΔu − ∇p + f, for t ≥ 0 (one-sided at t = 0). -/
def NSEq (ν : ℝ) (u : ℝ → E3 → E3) (p : ℝ → E3 → ℝ) (f : ℝ → E3 → E3) : Prop :=
  ∀ t : ℝ, 0 ≤ t → ∀ x : E3,
    derivWithin (fun s => u s x) (Set.Ici 0) t + advect (u t) x
      = ν • lap (u t) x - grad (p t) x + f t x

/-- (2): div u = 0. -/
def DivFree (u : ℝ → E3 → E3) : Prop := ∀ t : ℝ, 0 ≤ t → ∀ x, div (u t) x = 0

/-- (3): u(x,0) = u°(x). -/
def Initial (u : ℝ → E3 → E3) (u0 : E3 → E3) : Prop := ∀ x, u 0 x = u0 x

/-- (6)/(11): smooth on ℝ³ × [0,∞). -/
def SmoothHalf {F : Type*} [NormedAddCommGroup F] [NormedSpace ℝ F]
    (g : ℝ → E3 → F) : Prop :=
  ContDiffOn ℝ (⊤ : ℕ∞) (fun z : ℝ × E3 => g z.1 z.2) halfSpace

/-- Smooth, divergence-free initial datum. -/
def SmoothDivFree (u0 : E3 → E3) : Prop :=
  ContDiff ℝ (⊤ : ℕ∞) u0 ∧ ∀ x, div u0 x = 0

/-- (4): |∂^α u°(x)| ≤ C_{αK} (1+|x|)^{−K}. -/
def Decay (u0 : E3 → E3) : Prop :=
  ∀ (n : ℕ) (K : ℝ), ∃ C : ℝ, ∀ x, ‖iteratedFDeriv ℝ n u0 x‖ ≤ C / (1 + ‖x‖) ^ K

/-- (5): f smooth with |∂_x^α ∂_t^m f| ≤ C (1+|x|+t)^{−K} for t ≥ 0. -/
def ForceR3 (f : ℝ → E3 → E3) : Prop :=
  ContDiffOn ℝ (⊤ : ℕ∞) (fun z : ℝ × E3 => f z.1 z.2) halfSpace ∧
  ∀ (n : ℕ) (K : ℝ), ∃ C : ℝ, ∀ t : ℝ, 0 ≤ t → ∀ x,
    ‖iteratedFDerivWithin ℝ n (fun z : ℝ × E3 => f z.1 z.2) halfSpace (t, x)‖
      ≤ C / (1 + ‖x‖ + t) ^ K

/-- (7): bounded energy, ∫ |u(x,t)|² dx < C for all t ≥ 0. -/
def FiniteEnergy (u : ℝ → E3 → E3) : Prop :=
  ∃ C : ℝ, ∀ t : ℝ, 0 ≤ t →
    Integrable (fun x => ‖u t x‖ ^ 2) ∧ ∫ x, ‖u t x‖ ^ 2 < C

/-- (8): u°(x + e_j) = u°(x). -/
def PeriodicDatum (u0 : E3 → E3) : Prop := ∀ j x, u0 (x + e j) = u0 x

/-- (10): space-periodic in x for every t ≥ 0. -/
def PeriodicField {F : Type*} (g : ℝ → E3 → F) : Prop :=
  ∀ t : ℝ, 0 ≤ t → ∀ j x, g t (x + e j) = g t x

/-- (9): f periodic in x, smooth, with |∂_x^α ∂_t^m f| ≤ C (1+t)^{−K} for t ≥ 0. -/
def ForceTorus (f : ℝ → E3 → E3) : Prop :=
  ContDiffOn ℝ (⊤ : ℕ∞) (fun z : ℝ × E3 => f z.1 z.2) halfSpace ∧
  (∀ t : ℝ, 0 ≤ t → ∀ j x, f t (x + e j) = f t x) ∧
  ∀ (n : ℕ) (K : ℝ), ∃ C : ℝ, ∀ t : ℝ, 0 ≤ t → ∀ x,
    ‖iteratedFDerivWithin ℝ n (fun z : ℝ × E3 => f z.1 z.2) halfSpace (t, x)‖
      ≤ C / (1 + t) ^ K

def zeroForce : ℝ → E3 → E3 := fun _ _ => 0

/-- Solution class on ℝ³: (1), (2), (3), (6), (7). -/
def SolR3 (ν : ℝ) (u0 : E3 → E3) (f : ℝ → E3 → E3) : Prop :=
  ∃ (u : ℝ → E3 → E3) (p : ℝ → E3 → ℝ),
    NSEq ν u p f ∧ DivFree u ∧ Initial u u0 ∧
    SmoothHalf u ∧ SmoothHalf p ∧ FiniteEnergy u

/-- Solution class on the torus: (1), (2), (3), (10), (11). -/
def SolTorus (ν : ℝ) (u0 : E3 → E3) (f : ℝ → E3 → E3) : Prop :=
  ∃ (u : ℝ → E3 → E3) (p : ℝ → E3 → ℝ),
    NSEq ν u p f ∧ DivFree u ∧ Initial u u0 ∧
    PeriodicField u ∧ PeriodicField p ∧ SmoothHalf u ∧ SmoothHalf p

/-- (A) Existence and smoothness of Navier–Stokes solutions on ℝ³. -/
def StatementA : Prop :=
  ∀ ν : ℝ, 0 < ν → ∀ u0 : E3 → E3,
    SmoothDivFree u0 → Decay u0 → SolR3 ν u0 zeroForce

/-- (B) Existence and smoothness of Navier–Stokes solutions on ℝ³/ℤ³. -/
def StatementB : Prop :=
  ∀ ν : ℝ, 0 < ν → ∀ u0 : E3 → E3,
    SmoothDivFree u0 → PeriodicDatum u0 → SolTorus ν u0 zeroForce

/-- (C) Breakdown of Navier–Stokes solutions on ℝ³. -/
def StatementC : Prop :=
  ∀ ν : ℝ, 0 < ν → ∃ (u0 : E3 → E3) (f : ℝ → E3 → E3),
    SmoothDivFree u0 ∧ Decay u0 ∧ ForceR3 f ∧ ¬ SolR3 ν u0 f

/-- (D) Breakdown of Navier–Stokes solutions on ℝ³/ℤ³. -/
def StatementD : Prop :=
  ∀ ν : ℝ, 0 < ν → ∃ (u0 : E3 → E3) (f : ℝ → E3 → E3),
    SmoothDivFree u0 ∧ PeriodicDatum u0 ∧ ForceTorus f ∧ ¬ SolTorus ν u0 f

/-- The Clay prize condition: a proof of any one of (A), (B), (C), (D). -/
def ClayNavierStokes : Prop :=
  StatementA ∨ StatementB ∨ StatementC ∨ StatementD
```

## Shared definitions (equation, initial data, smoothness, energy, decay, force, periodicity clauses)
```lean
/-- (1): ∂_t u + (u·∇)u = νΔu − ∇p + f, for t ≥ 0 (one-sided at t = 0). -/
def NSEq (ν : ℝ) (u : ℝ → E3 → E3) (p : ℝ → E3 → ℝ) (f : ℝ → E3 → E3) : Prop :=
  ∀ t : ℝ, 0 ≤ t → ∀ x : E3,
    derivWithin (fun s => u s x) (Set.Ici 0) t + advect (u t) x
      = ν • lap (u t) x - grad (p t) x + f t x

/-- (2): div u = 0. -/
def DivFree (u : ℝ → E3 → E3) : Prop := ∀ t : ℝ, 0 ≤ t → ∀ x, div (u t) x = 0

/-- (3): u(x,0) = u°(x). -/
def Initial (u : ℝ → E3 → E3) (u0 : E3 → E3) : Prop := ∀ x, u 0 x = u0 x

/-- (6)/(11): smooth on ℝ³ × [0,∞). -/
def SmoothHalf {F : Type*} [NormedAddCommGroup F] [NormedSpace ℝ F]
    (g : ℝ → E3 → F) : Prop :=
  ContDiffOn ℝ (⊤ : ℕ∞) (fun z : ℝ × E3 => g z.1 z.2) halfSpace

/-- Smooth, divergence-free initial datum. -/
def SmoothDivFree (u0 : E3 → E3) : Prop :=
  ContDiff ℝ (⊤ : ℕ∞) u0 ∧ ∀ x, div u0 x = 0

/-- (4): |∂^α u°(x)| ≤ C_{αK} (1+|x|)^{−K}. -/
def Decay (u0 : E3 → E3) : Prop :=
  ∀ (n : ℕ) (K : ℝ), ∃ C : ℝ, ∀ x, ‖iteratedFDeriv ℝ n u0 x‖ ≤ C / (1 + ‖x‖) ^ K

/-- (5): f smooth with |∂_x^α ∂_t^m f| ≤ C (1+|x|+t)^{−K} for t ≥ 0. -/
def ForceR3 (f : ℝ → E3 → E3) : Prop :=
  ContDiffOn ℝ (⊤ : ℕ∞) (fun z : ℝ × E3 => f z.1 z.2) halfSpace ∧
  ∀ (n : ℕ) (K : ℝ), ∃ C : ℝ, ∀ t : ℝ, 0 ≤ t → ∀ x,
    ‖iteratedFDerivWithin ℝ n (fun z : ℝ × E3 => f z.1 z.2) halfSpace (t, x)‖
      ≤ C / (1 + ‖x‖ + t) ^ K

/-- (7): bounded energy, ∫ |u(x,t)|² dx < C for all t ≥ 0. -/
def FiniteEnergy (u : ℝ → E3 → E3) : Prop :=
  ∃ C : ℝ, ∀ t : ℝ, 0 ≤ t →
    Integrable (fun x => ‖u t x‖ ^ 2) ∧ ∫ x, ‖u t x‖ ^ 2 < C

```

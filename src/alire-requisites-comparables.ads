generic
   --  Encapsulated basic type
   type Value is private;
   with function "<" (L, R : Value) return Boolean;
   with function Image (V : Value) return String is <>;

   --  Encapsulating property
   type Property is new Properties.Property with private;
   with function Element (P : Property) return Value;

   Name : String; -- used for image "Name (operation) Mixed_Case (Image (Value))"
package Alire.Requisites.Comparables with Preelaborate is

   package Value_Requisites is new For_Property (Property);

   type Comparable (<>) is new Value_Requisites.Requisite with private;

   overriding function Is_Satisfied (R : Comparable; P : Property) return Boolean;
   overriding function Image        (R : Comparable) return String;

   not overriding function New_Comparable return Comparable;
   --  This is the root function that can be renamed to a sensible name to appear in expressions

   function "=" (L : Comparable; R : Value) return Tree;
   function "=" (L : Value; R : Comparable) return Tree;

   function "/=" (L : Comparable; R : Value) return Tree;
   function "/=" (L : Value; R : Comparable) return Tree;

   function "<" (L : Comparable; R : Value) return Tree;
   function "<" (L : Value; R : Comparable) return Tree;

   function "<=" (L : Comparable; R : Value) return Tree;
   function "<=" (L : Value; R : Comparable) return Tree;

   function ">" (L : Comparable; R : Value) return Tree;
   function ">" (L : Value; R : Comparable) return Tree;

   function ">=" (L : Comparable; R : Value) return Tree;
   function ">=" (L : Value; R : Comparable) return Tree;

private

   type Kinds is (Base, Equality, Ordering);

   type Comparable (Kind : Kinds) is new Value_Requisites.Requisite with record
      Value : Comparables.Value;
   end record;

   not overriding function New_Comparable return Comparable is (Kind => Base, Value => <>);

   overriding function Is_Satisfied (R : Comparable; P : Property) return Boolean is
     (case R.Kind is
         when Base     => raise Constraint_Error with "Is_Satisfied: Requisite without operation",
         when Equality => R.Value = Element (P),
         when Ordering => R.Value < Element (P));

   overriding function Image (R : Comparable) return String is
     (case R.Kind is
         when Base     => raise Constraint_Error with "Image: Requisite without operation",
         when Equality => Name & " = " & Image (R.Value),
         when Ordering => Name & " < " & Image (R.Value));

   use all type Tree;

   function "/=" (L : Comparable; R : Value) return Tree is (not (L = R));
   function "/=" (L : Value; R : Comparable) return Tree is (not (L = R));

   function "<=" (L : Comparable; R : Value) return Tree is (L < R or L = R);
   function "<=" (L : Value; R : Comparable) return Tree is (L < R or L = R);

   function ">" (L : Comparable; R : Value) return Tree is (not (L <= R));
   function ">" (L : Value; R : Comparable) return Tree is (not (L <= R));

   function ">=" (L : Comparable; R : Value) return Tree is (not (L < R));
   function ">=" (L : Value; R : Comparable) return Tree is (not (L < R));

   function "=" (L : Comparable; R : Value) return Tree is
     (Trees.Leaf (Comparable'(Kind => Equality, Value => R)));

   function "=" (L : Value; R : Comparable) return Tree is (R = L);

   function "<" (L : Comparable; R : Value) return Tree is
      (Trees.Leaf (Comparable'(Kind => Ordering, Value => R)));

   function "<" (L : Value; R : Comparable) return Tree is (R >= L);

end Alire.Requisites.Comparables;

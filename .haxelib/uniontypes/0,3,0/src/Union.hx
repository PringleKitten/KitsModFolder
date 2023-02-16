@:genericBuild(uniontypes.macro.UnionBuilder.build())
class Union<T, T2> {}

@:genericBuild(uniontypes.macro.UnionBuilder.build(true))
class TrustedUnion<T, T2> {}

@:genericBuild(uniontypes.macro.UnionBuilder.build(false))
class UntrustedUnion<T, T2> {}
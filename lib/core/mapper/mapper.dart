abstract class Mapper<E, D> {
  E toEntity(D dto);
  D toDto(E entity);

  List<E> toEntityList(List<D> dtos) => List.of(dtos.map((e) => toEntity(e)));
  List<D> toDtoList(List<E> entities) => List.of(entities.map((e) => toDto(e)));
}

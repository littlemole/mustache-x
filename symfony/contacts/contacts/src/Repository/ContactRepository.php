<?php

namespace App\Repository;

use App\Entity\Contact;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<Contact>
 *
 * @method Contact|null find($id, $lockMode = null, $lockVersion = null)
 * @method Contact|null findOneBy(array $criteria, array $orderBy = null)
 * @method Contact[]    findAll()
 * @method Contact[]    findBy(array $criteria, array $orderBy = null, $limit = null, $offset = null)
 */
class ContactRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Contact::class);
    }

    public function search(string $text ): array
    {
        $qb = $this->createQueryBuilder('c')
            ->where('c.first like :text or c.last like :text')
            ->setParameter('text', $text."%");

        $query = $qb->getQuery();

        return $query->execute();
    }    

    public function find_by_email(string $email ): ?Contact
    {
        $qb = $this->createQueryBuilder('c')
            ->where('c.email = :email')
            ->setParameter('email', $email);

        $query = $qb->getQuery();

        $query->execute();

        return $query->setMaxResults(1)->getOneOrNullResult();
    }    

    public function contacts_count( ): int
    {
        $conn = $this->getEntityManager()->getConnection();

        $sql = 'SELECT COUNT(*) FROM contacts';

        $resultSet = $conn->executeQuery($sql);

        return $resultSet->fetchOne();
    }    

}

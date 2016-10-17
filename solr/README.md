## Quick Background: Apache Solr

Apache Solr, is a specific No SQL technology, optimized for a unique class of
problems: Solr is a scalable, enterprise search engine that’s optimized to search
large volumes of text-centric data.

Search engines like Solr are optimized to handle data exhibiting four main 
characteristics:

* Text-centric
* Read-dominant
* Document-oriented
* Flexible schema

**Text-centric** a search engine is specifically designed to extract the implicit 
structure of text into its index to improve searching. Text-centric data implies
that the text of a document contains information that users are interested in 
finding.

**Read-dominant** key aspect of data that search engines handle effectively is 
that data is read-dominant and therefore intended to be accessed efficiently, 
as opposed to updated frequently. A search engine has been optimized for 
executing queries (a read operation), for example, as opposed to storing 
data (a write operation).

**Document-oriented** search engines work with documents. In a search engine, a 
document is a self-contained collection of fields, in which each field only holds 
data and doesn’t contain nested fields. In other words, a document in a search 
engine like Solr has a flat structure and doesn’t depend on other documents. 
The flat concept is slightly relaxed in Solr, in that a field can have multiple 
values, but fields don’t contain subfields. You can store multiple values in a 
single field, but you can’t nest fields inside of other fields.

**Flexible schema** The last main characteristic of search-engine data is that
it has a flexible schema. This means that documents in a search index don’t need 
to have a uniform structure. In a relational database, every row in a table has 
the same structure. In Solr, documents can have different fields.

Search engines in general and Solr in particular are optimized to handle data 
having four specific characteristics: text-centric, read-dominant, 
document-oriented, and flexible schema. Overall, this implies that **Solr is not 
a general-purpose data-storage and processing technology.**

## Why is important Apache Solr in a Big Data ecosystem?


## Getting started with Solr

``````
$ wget http://www-eu.apache.org/dist/flume/1.6.0/apache-flume-1.6.0-bin.tar.gz
``````
## Kafka in Containers (Docker)

## Kafka cluster in OpenShift

